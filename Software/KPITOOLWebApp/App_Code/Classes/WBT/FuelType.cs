using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.WBT
{
    /// <summary>
    /// Summary description for FuelType
    /// </summary>
    public class FuelType
    {
        public int ID { get; set; }
        public string TreeSpecies { get; set; }
        public double HHV { get; set; }
        public double LHV { get; set; }
        public int CharKj { get; set; }
        public double MassFrac { get; set; }
        public int Source { get; set; }

        public static FuelType[] fuelList ={ 
                new FuelType() { ID=2, TreeSpecies="LPG", HHV=48000, LHV=44700,CharKj=0, MassFrac=0.818, Source=0},
                new FuelType() { ID=3, TreeSpecies="Kerosene", HHV=43300, LHV=39700,CharKj=0, MassFrac=0.845, Source=0},
                new FuelType() { ID=4, TreeSpecies="Ethanol", HHV=26800, LHV=24200,CharKj=0, MassFrac=0.522, Source=0},
                new FuelType() { ID=5, TreeSpecies="Methanol", HHV=22700, LHV=21100,CharKj=0, MassFrac=0.375, Source=0},
                new FuelType() { ID=6, TreeSpecies="Charcoal", HHV=31000, LHV=29800,CharKj=29800, MassFrac=0.95, Source=0},
                new FuelType() { ID=7, TreeSpecies="Coal", HHV=24700, LHV=23500,CharKj=29500, MassFrac=0.75, Source=0},
                new FuelType() { ID=8, TreeSpecies="Crop residues", HHV=14700, LHV=13380,CharKj=29500, MassFrac=0.5, Source=0},
                new FuelType() { ID=9, TreeSpecies="Dung", HHV=13600, LHV=12280,CharKj=29500, MassFrac=0.5, Source=0},
                new FuelType() { ID=10, TreeSpecies="Average Hardwood", HHV=19734, LHV=18414,CharKj=29500, MassFrac=0.5, Source=3},
                new FuelType() { ID=11, TreeSpecies="Average Softwood (Conifer)", HHV=20817, LHV=19497,CharKj=29500, MassFrac=0.5, Source=3},
                new FuelType() { ID=12, TreeSpecies="Abies Balsamea (Balsam Fir)", HHV=18916.15, LHV=17596.15,CharKj=29500, MassFrac=0.5, Source=2},
                new FuelType() { ID=13, TreeSpecies="Acacia Auriculiformis (Ear-Leaf Acacia, Ear-Pod Wattle)", HHV=20370, LHV=19050,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=14, TreeSpecies="Acacia Decurrens  (King Wattle, Green Wattle, Sydney Black Wattle)", HHV=18700, LHV=17380,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=15, TreeSpecies="Acacia Farnesiana (Sweet Acacia, Sweet Wattle)", HHV=19200, LHV=17880,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=16, TreeSpecies="Acacia Leucophloea (Kikar, Kuteeera Gum)", HHV=21800, LHV=20480,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=17, TreeSpecies="Acacia Mearnsi  (Black Wattle)", HHV=19530, LHV=18210,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=18, TreeSpecies="Acacia Nilotica (Egyptian Thorn, Babul (India), Babar (Pakistan))", HHV=20475, LHV=19155,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=19, TreeSpecies="Acacia Tortilis (Umbrella Thorn)", HHV=18480, LHV=17160,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=20, TreeSpecies="Acer Rubrum (Red Maple)", HHV=18544.79, LHV=17224.79,CharKj=29500, MassFrac=0.5, Source=2},
                new FuelType() { ID=21, TreeSpecies="Albizia Falcataria (Batai, Malucca Albizia, ,Placata)", HHV=18100, LHV=16780,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=22, TreeSpecies="Albizia Lebbek (Lebbek, East Indian Walnut Tree) ", HHV=21840, LHV=20520,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=23, TreeSpecies="Albizia Procera (Albicia, Silver Bark Rain Tree)", HHV=19700, LHV=18380,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=24, TreeSpecies="Alnus Nepalensis (Nepal Alder)", HHV=17150, LHV=15830,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=25, TreeSpecies="Alnus Rubra (Red Alder)", HHV=19320, LHV=18000,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=26, TreeSpecies="Alnus Rubra (Red Alder)", HHV=18544.79, LHV=17224.79,CharKj=29500, MassFrac=0.5, Source=2},
                new FuelType() { ID=27, TreeSpecies="Alstonia Macrophylla (Devil Tree)", HHV=19200, LHV=17880,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=28, TreeSpecies="Anogeissus Latifolia (Axle-Wood Tree, Dhausa (Hindi))", HHV=20580, LHV=19260,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=29, TreeSpecies="Anthocephalus Cadamba (Labula (Indonesia))", HHV=19350, LHV=18030,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=30, TreeSpecies="Antidesma Ghaessimbilla", HHV=19100, LHV=17780,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=31, TreeSpecies="Avicennia Officinalis (Mangrove, Api-Api Sudu (Philippines))", HHV=18500, LHV=17180,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=32, TreeSpecies="Balanites Aegyptiaca (Desert Date, Thorn Tree, Soapberry Tree)", HHV=19320, LHV=18000,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=33, TreeSpecies="Bruguiera Gymnorrhiza (Black Mangrove, Large-Leafed Mangrove)", HHV=20400, LHV=19080,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=34, TreeSpecies="Bruguiera Parviflora (Thua Shale, Slender-Fruited Orange Mangrove)", HHV=18700, LHV=17380,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=35, TreeSpecies="Bruguiera Sexangula (Orange Mangrove)", HHV=19400, LHV=18080,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=36, TreeSpecies="Calliandra Calothyrsus (Calliandra)", HHV=19425, LHV=18105,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=37, TreeSpecies="Carya Spp (Hickory)", HHV=18684.05, LHV=17364.05,CharKj=29500, MassFrac=0.5, Source=2},
                new FuelType() { ID=38, TreeSpecies="Cassia Fistula (Cassia Stick Tree, Guayaba Cimarrona, Canafistula, Golden Shower, Indian Laburnum, Baton ‎Casse, Chacara, Nanban-Saikati, Kachang Kayu (Woody Bean), Kallober, Keyok, Klober)", HHV=18400, LHV=17080,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=39, TreeSpecies="Cassia Siamea (Siamese Cassia)", HHV=18800, LHV=17480,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=40, TreeSpecies="Casuarina Equistofolia (Casuarina, She-Oak, Whistling Pine)", HHV=20790, LHV=19470,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=41, TreeSpecies="Ceriops Tagal (Tagal Mangrove, Kandal)", HHV=19600, LHV=18280,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=42, TreeSpecies="Cocus Nucifera (Coconut Palm)", HHV=19000, LHV=17680,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=43, TreeSpecies="Cordia Dichotoma (Anunang (Philippines), Bird Lime Tree)", HHV=18400, LHV=17080,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=44, TreeSpecies="Dalbergia Latifolia (East Indian Rosewood, Malabar Rosewood, Sitsal, Beete, Shisham)", HHV=19800, LHV=18480,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=45, TreeSpecies="Dalbergia Sissoo (Sissoo, Shisham, Karra, Shewa)", HHV=21210, LHV=19890,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=46, TreeSpecies="Derris Indica (India: Pongam, Ponga, Kona, Kanji, Karanja, Karanda; English: Indian Beech)", HHV=19320, LHV=18000,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=47, TreeSpecies="Diospyros Philippinensis (Kamagong (Philippines))", HHV=18600, LHV=17280,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=48, TreeSpecies="Diospyros Philosanthera (Bolong-Eta (Philippines))", HHV=18100, LHV=16780,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=49, TreeSpecies="Emblica Ofiicinalis (Madre De Cacao, Kakauati (Philippines), Mexican Lilac, Madera Negra)", HHV=21840, LHV=20520,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=50, TreeSpecies="Eucalyptus Camaldulensis (Red River Gum, Red Gum)", HHV=20160, LHV=18840,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=51, TreeSpecies="Eucalyptus Deglupta (Rainbow Gum Tree)", HHV=18700, LHV=17380,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=52, TreeSpecies="Eucalyptus Globulus (Southern Blue Gum, Fever Tree)", HHV=20160, LHV=18840,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=53, TreeSpecies="Eucalyptus Grandis (Rose Gum, Grand Eucalyptus)", HHV=19750, LHV=18430,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=54, TreeSpecies="Fagus Spp (Beech)", HHV=18916.15, LHV=17596.15,CharKj=29500, MassFrac=0.5, Source=2},
                new FuelType() { ID=55, TreeSpecies="Gigantochloa Apus (Pring Tali, Tabasheer Bamboo)", HHV=18400, LHV=17080,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=56, TreeSpecies="Gliricidia Sepium", HHV=20580, LHV=19260,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=57, TreeSpecies="Gmelina Arborea (Gmelina, Gumhar (India))", HHV=20160, LHV=18840,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=58, TreeSpecies="Lagerstroemia Speciosa (Queen's Crape Myrtle, Giant Crape Myrtle)", HHV=19300, LHV=17980,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=59, TreeSpecies="Leucaena Leucocephala (Leucaena, Ipil-Ipil (Philippines), Uaxin (Latin America), Lamtora (Indonesia), Lead Tree)", HHV=18480, LHV=17160,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=60, TreeSpecies="Melia Azedarach (China Berry, Persian Lilac, Bead Tree, Cape Lilac)", HHV=21459.9, LHV=20139.9,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=61, TreeSpecies="Pinus Elliotii (Southern Pine)", HHV=19960.6, LHV=18640.6,CharKj=29500, MassFrac=0.5, Source=2},
                new FuelType() { ID=62, TreeSpecies="Pinus Ponderosa (Ponderosa Pine)", HHV=18684.05, LHV=17364.05,CharKj=29500, MassFrac=0.5, Source=2},
                new FuelType() { ID=63, TreeSpecies="Pithecellobium Dulce (Quamachil, Guamuchil (Mexico), Manila Tamarind)", HHV=22680, LHV=21360,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=64, TreeSpecies="Platanus Occidentalis (Sycamore)", HHV=18544.79, LHV=17224.79,CharKj=29500, MassFrac=0.5, Source=2},
                new FuelType() { ID=65, TreeSpecies="Populus Euphratica (Euphrates Poplar, Saf-Saf, Indian Poplar)", HHV=21056.7, LHV=19736.7,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=66, TreeSpecies="Populus Trichocarpa (Black Cottonwood)", HHV=20424.8, LHV=19104.8,CharKj=29500, MassFrac=0.5, Source=2},
                new FuelType() { ID=67, TreeSpecies="Prosopis Cineraria (Jand, Khejri (India))", HHV=21000, LHV=19680,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=68, TreeSpecies="Prosopis Pallida (Kiawe)", HHV=19750, LHV=18430,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=69, TreeSpecies="Pseudotsuga Menziesii (Douglas Fir)", HHV=20633.69, LHV=19313.69,CharKj=29500, MassFrac=0.5, Source=2},
                new FuelType() { ID=70, TreeSpecies="Psidium Guajava  (Guava, Guayaba)", HHV=20126.4, LHV=18806.4,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=71, TreeSpecies="Quercus Bicolor (White Oak)", HHV=18916.15, LHV=17596.15,CharKj=29500, MassFrac=0.5, Source=2},
                new FuelType() { ID=72, TreeSpecies="Quercus Rubra  (Red Oak)", HHV=18684.05, LHV=17364.05,CharKj=29500, MassFrac=0.5, Source=2},
                new FuelType() { ID=73, TreeSpecies="Rhizophera Spp (Mangrove Spp (Also Avicennia Spp))", HHV=17430, LHV=16110,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=74, TreeSpecies="Sapium Sebiferum (Chinese Tallow Tree, Soap Tree, Tarchabi (Pahari) Shishum (India))", HHV=17663.1, LHV=16343.1,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=75, TreeSpecies="Schima Noronhae", HHV=20000, LHV=18680,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=76, TreeSpecies="Schleichera Oleosa (Kosambi (Indonesia), Lac Tree)", HHV=18700, LHV=17380,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=77, TreeSpecies="Sesbania Grandiflora (Scarlet Wisteria Tree, Agati, Corkwood Tree, West Indian Pea)", HHV=19300, LHV=17980,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=78, TreeSpecies="Swietenia Macrophylla (Brazilian Mahogany, Caoba, Honduras Mahogany, Big Leaf Mahogany)", HHV=20700, LHV=19380,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=79, TreeSpecies="Syzygium Cumini (Jambolan, Java Plum)", HHV=20160, LHV=18840,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=80, TreeSpecies="Thuja Plicata (Western Red Cedar)", HHV=22513.7, LHV=21193.7,CharKj=29500, MassFrac=0.5, Source=2},
                new FuelType() { ID=81, TreeSpecies="Trema Spp", HHV=18900, LHV=17580,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=82, TreeSpecies="Tsuga Canadensis (Eastern Hemlock)", HHV=19519.61, LHV=18199.61,CharKj=29500, MassFrac=0.5, Source=2},
                new FuelType() { ID=83, TreeSpecies="Tsuga Heterophylla (Western Hemlock)", HHV=19519.61, LHV=18199.61,CharKj=29500, MassFrac=0.5, Source=2},
                new FuelType() { ID=84, TreeSpecies="Ulmus Spp (Elm)", HHV=18962.57, LHV=17642.57,CharKj=29500, MassFrac=0.5, Source=2},
                new FuelType() { ID=85, TreeSpecies="Xylocarpus Granatum (Cannonball Mangrove, Cedar Mangrove)", HHV=16300, LHV=14980,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=86, TreeSpecies="Xylocarpus Moluccensis (Cedar Mangrove)", HHV=15400, LHV=14080,CharKj=29500, MassFrac=0.5, Source=4},
                new FuelType() { ID=87, TreeSpecies="Zizyphus Mauritania (Indian Jujube, Indian Plum)", HHV=20580, LHV=19260,CharKj=29500, MassFrac=0.5, Source=1},
                new FuelType() { ID=88, TreeSpecies="Zizyphus Talanai", HHV=18300, LHV=16980,CharKj=29500, MassFrac=0.5, Source=4}
        };

        public FuelType()
        {
        }

        public static string GetTypeFuelByID(int fuelId)
        {
            return FuelType.fuelList[fuelId - 2].TreeSpecies;
        }

        public static double GetHHVByID(int fuelId)
        {
            return FuelType.fuelList[fuelId - 2].HHV;
        }

        public static double GetLHVByID(int fuelId)
        {
            return FuelType.fuelList[fuelId - 2].LHV;
        }

        public static int GetCharKjByID(int fuelId)
        {
            return FuelType.fuelList[fuelId - 2].CharKj;
        }

        public static double GetMassFracByID(int fuelId)
        {
            return FuelType.fuelList[fuelId - 2].MassFrac;
        }

        public static int GetSourceByID(int fuelId)
        {
            return FuelType.fuelList[fuelId - 2].Source;
        }
    }
}