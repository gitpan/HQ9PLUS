system($^X, 'lib/hq9p.PL');

use ExtUtils::MakeMaker;

WriteMakefile(
  'NAME'      => 'HQ9PLUS',
  'VERSION'   => '0.1',

  'EXE_FILES' =>  [ 'lib/hq9p' ],

  'MAN1PODS'  => {
    'lib/hq9p' => '$(INST_MAN1DIR)/hq9p.1',
  },
  
  clean => { FILES => 'lib/hq9p' },
);
