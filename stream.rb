# https://github.com/intridea/tweetstream

require 'tweetstream'


TweetStream.configure do |config|
  config.consumer_key       = 'J9CJL5Uwn8XvqDVTCwuPlQ'
  config.consumer_secret    = '4x3MWKVAB5oOTcgxdmjvTKr5uVpZTaEHeZxSGcFNU'
  config.oauth_token        = '14759621-MO6xonCXtdg9zJm1eAgk9CO05Rq6lZ48NZV0lgaNN'
  config.oauth_token_secret = 'iRZMVx4Gg6ejARtGdLADykkBB06rvNsf1QmvJ4L1Z5U'
  config.auth_method        = :oauth
end


ENV["RAILS_ENV"] ||= "production"

root = File.expand_path( File.dirname(__FILE__) )
require File.join(root, "config", "environment")

daemon = TweetStream::Daemon.new('tracker', :log_output => true)
daemon.on_inited do
  ActiveRecord::Base.connection.reconnect!
end

all_reps = [34972633,263815367,23600262,15281676,23951197,219429281,29501253,58928690,296245061,41017380,1055730738,240376522,18696134,156333623,950783972,20209807,199325935,960962340,249348006,1090002997,1058717720,1051446626,234797704,248735463,19318314,82453460,1134292500,516880804,55677432,237312687,1080509366,233949261,211530910,74508260,25086658,22527499,21572351,17896154,305216911,234822928,37920978,1071840474,30216513,518644221,114607567,33576489,29293808,305620929,15281676,126171100,258900199,150724371,17976923,267854863,48086014,249339682,132204008,235190657,21312077,14984637,1092979962,1058256326,1072008757,234937222,1289319271,18137749,235373000,292935209,235217558,22831059,19139963,242761889,1045110018,1009269193,1057859527,281540744,22509548,28176898,462143773,976969338,510516465,240427862,155669457,16102244,52503751,229197216,168673083,1128514404,115979444,33655490,1068499286,1058917562,344972339,28599820,110545675,122174004,402029058,1155335864,82649553,37007274,38254095,1060487274,1069124515,584012853,221793778,137823987,168502762,108839478,20552026,21406834,246769138,234906311,787373558,164007407,1060984272,163570705,18891923,233693291,942156122,17513304,851621377,1083448909,241207373,389017497,31801993,237418907,234014087,124224165,1089334250,155642785,236511574,111635527,432676344,1058460818,7356562,78445977,18967498,1027156464,1051127714,161411080,23712174,22812754,32010840,26051676,22669526,234057152,467823431,550401754,210926192,24745957,785414496,314335929,16348437,14275291,15160884,24913074,1065995022,36654245,242926427,188019606,31611298,18909919,225921757,242426145,47412499,236916916,339852137,24195214,1071102246,463132556,17800215,18566912,248699486,240393970,18805303,1061292174,40302336,385429543,1092757885,22523087,245451804,40954486,18166778,46016028,132201224,231510077,190798793,19929362,85396297,11527072,254082173,22812434,7713202,248718904,237770636,18030431,138770045,24183358,937723303,109025212,84620376,88806753,76350004,50452197,29450962,562965097,364415553,15600527,384392601,384913290,309267226,111635980,222286905,1055907624,198526130,33563161,1260172386,193732179,1243902714,233842454,295685416,239949176,161743731,14135426,1155212191,22545491,23976316,966442267,19926675,1048784496,19739126,252819642,235251868,20545793,1080844782,15856366,234812598,18317325,613725908,312134473,153944899,292990703,1077121945,108376246,239871673,22055226,63169388,479872233,36948268,1045853744,19658173,137407124,377534571,153486399,1074129612,581141508,37094727,402719755,963480595,1206227149,1037321378,1060370282,211901075,278145569,224294785,776664410,1072382221,36686040,257169015,15751083,75785294,39249305,237944147,235239775,16583468,26424123,19918558,76132891,51228911,18217624,1061385474,240385577,19407835,935368364,217547360,244268646,56864092,156703580,303861808,237299871,15764644,242892689,221792092,164369297,27676828,248850174,1128781184,912608010,18811140,1074412920,240760644,18916432,84119348,1072453910,20053279,252249233,18277655,20015903,193872188,1410590874,24735461,32506723,1154894353,237814920,34340464,1058051748,1089859058,28602948,246341769,234053893,213634439,236899846,935033864,442824717,1055685948,236479311,404132211,148006729,76452765,272491182,148453195,234837632,15394954,950328072,161791703,15356407,152018565,234490845,993153006,1077446982,612117635,1058807868,112740986,140519774,239905257,111379452,158398519,249288197,25781141,249410485,235312723,960696949,18773159,1135486501,242873057,234022257,1072467470,80612021,193794406,78431501,22012091,249219716,310310133,235271965,237750442,162069635,11651202,20002401,48117116,389840566,299883942,1209417007,237781383,211420609,1059240924,234469322,1074101017,53941120,995193054,558769636,1058520120,74198348,1071900114,381152398,137794015,975200486,23970171,201079432,233761277,117777832,153919023,1262814457,13491312,237862972,17544524,234128524,23124635,968650362,190328374,10102032,240363117,50152441,6577802,252819323,1058345042,1222257180,24773493,237348797,17198100,1064206014,20467163,237763317,16256269,26778110,1068470480,232992031,227088228,133832049,240812994,267938462,7334402,33537967,1068481578,15442036,132278386,109071031,29442313,20597460,73303753,1262099252,93761782,10615232,17494010,435500714,150078976,57065141,212262370,19028248,266133081,76456274,1071402577,476256944,970207298,135297032,16789970,1061029050,20546536,1096059529,109287731,47975734,16056306,29201047,18632666,216503958,234374703,202206694,5558312,13218102,382791093,78403308,19394188,486694111,273559002,296361085,16473577,74171837,229592356,72198806,76649729,14845376,18061669,229966028,117501995,83901492,211588974,426655227,8128442,7429102,1099199839,413466731,346637907,92186819,224285242,600463589,291756142,194720228,88784440,339822881,262756641,242836537,221162525,75364211,293131808,216881337,278124059,21157904,247334603,21111098,171598736,18695134,18915145,264219447,233737858,250188760,21269970,538185166,242555999,43910797,19726613,1074518754,1074480192,555474658,249787913,18216752,115733549,244243985,1267940407,217543151,60828944,1151590614]


daemon.track('#soundoff').follow( all_reps ) do |tweet|
	Tweet.create_from_tweet(tweet)
end