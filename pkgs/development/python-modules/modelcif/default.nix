{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  ihm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "modelcif";
  version = "1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ihmwg";
    repo = "python-modelcif";
    tag = version;
    hash = "sha256-3wuKD6oQp3QdsWRpYsnC5IPpVRcQVDERSClEKJko3dg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [ ihm ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # require network access
    "test_associated_example"
    "test_validate_mmcif_example"
    "test_validate_modbase_example"
  ];

  pythonImportsCheck = [ "modelcif" ];

  meta = with lib; {
    description = "Python package for handling ModelCIF mmCIF and BinaryCIF files";
    homepage = "https://github.com/ihmwg/python-modelcif";
    changelog = "https://github.com/ihmwg/python-modelcif/blob/${src.rev}/ChangeLog.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
