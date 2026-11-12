// LIMIAR — teste mínimo de renderização RAEA (ambiente, não asset de jogo).
// Graybox de nave gótica: colunas, piso, altar, luz de vela âmbar, fenda violeta do Eco, névoa e pixelização.
// Paleta da Art Bible (docs/pre-producao/docs/05_ART_BIBLE.md §3). Render:
//   raea render tools/raea/smoke_cathedral.tsx --frame 0 -o out/raea/smoke_cathedral.png
import { AbsoluteFill, Composition, registerRoot } from "raea";
import { Bloom, Fog, Look, ToneMapping } from "raea/3d";
import { LinearRgba, Srgba } from "raea/color";
import { StandardMaterial } from "raea/pbr";
import { Cuboid, Mesh3d } from "raea/mesh";
import { AmbientLight, DirectionalLight, PointLight } from "raea/light";
import { Transform } from "raea/transform";
import { Camera3d } from "raea/camera";

const ABISMO = "#11131B";
const PEDRA = "#303447";
const ECO = "#69465A";
const COBRE = "#A16D47";
const CULPA = "#9E393E";

function Column({ x, z }: { x: number; z: number }) {
  return (
    <Mesh3d name={`col_${x}_${z}`} transform={Transform.fromXyz(x, 3, z)}>
      <Cuboid half_size={[0.35, 3, 0.35]} />
      <StandardMaterial base_color={PEDRA} perceptual_roughness={0.9} />
    </Mesh3d>
  );
}

function Nave() {
  const zs = [-2, -6, -10, -14];
  return (
    <AbsoluteFill style={{ background: ABISMO }}>
      <Camera3d transform={Transform.fromXyz(0, 1.7, 3).lookingAt([0, 1.8, -12])} projection={{ Perspective: { fov: (70 * Math.PI) / 180 } }} />
      <AmbientLight brightness={180} color="#5a6a9a" />
      <DirectionalLight transform={Transform.fromXyz(-4, 8, 2).lookingAt([2, 0, -10])} illuminance={2500} color="#8fa6e0" shadow_maps_enabled />
      <Fog color={ABISMO} near={8} far={30} />
      <Bloom intensity={0.5} threshold={0.9} />
      <ToneMapping mode="agx" />
      <Look mode="pixel" pixelSize={4} />

      {/* piso e tapete */}
      <Mesh3d name="floor" transform={Transform.fromXyz(0, -0.05, -8)}>
        <Cuboid half_size={[5, 0.05, 14]} />
        <StandardMaterial base_color={PEDRA} perceptual_roughness={0.35} />
      </Mesh3d>
      <Mesh3d name="carpet" transform={Transform.fromXyz(0, 0.01, -8)}>
        <Cuboid half_size={[0.9, 0.01, 12]} />
        <StandardMaterial base_color={CULPA} perceptual_roughness={0.95} />
      </Mesh3d>

      {zs.map((z) => <Column key={`l${z}`} x={-3} z={z} />)}
      {zs.map((z) => <Column key={`r${z}`} x={3} z={z} />)}

      {/* altar e degraus */}
      <Mesh3d name="steps" transform={Transform.fromXyz(0, 0.3, -16)}>
        <Cuboid half_size={[3, 0.3, 1.2]} />
        <StandardMaterial base_color={PEDRA} perceptual_roughness={0.8} />
      </Mesh3d>
      <Mesh3d name="altar" transform={Transform.fromXyz(0, 1.1, -16.5)}>
        <Cuboid half_size={[1.2, 0.5, 0.5]} />
        <StandardMaterial base_color={COBRE} perceptual_roughness={0.6} />
      </Mesh3d>

      {/* velas: luz âmbar de presença */}
      {[-1, 1].map((x) => (
        <PointLight key={`candle${x}`} transform={Transform.fromXyz(x, 1.9, -16)} intensity={250000} color="#ffb060" range={14} shadows_enabled />
      ))}
      {[-2, -6, -10].map((z) => (
        <PointLight key={`sconce${z}`} transform={Transform.fromXyz(-2.5, 2.2, z)} intensity={60000} color="#ffa050" range={7} />
      ))}

      {/* fenda do Eco na parede direita: violeta, com forma própria (não depende só da cor) */}
      <Mesh3d name="eco_rift" transform={Transform.fromXyz(4.2, 2, -8)}>
        <Cuboid half_size={[0.05, 1.6, 0.25]} />
        <StandardMaterial base_color={ECO} emissive={LinearRgba.from(Srgba.hex("#9a6cff")).mul(6)} />
      </Mesh3d>
      <PointLight transform={Transform.fromXyz(3.6, 2, -8)} intensity={25000} color="#9a6cff" range={6} />
    </AbsoluteFill>
  );
}

registerRoot(() => <Composition id="smoke-cathedral" component={Nave} width={1280} height={720} fps={30} durationInFrames={1} />);
