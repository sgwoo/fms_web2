<%
    /* ============================================================================== */
    /* =   PAGE : ���� ���� ȯ�� ���� PAGE                                          = */
    /* = -------------------------------------------------------------------------- = */
    /* =   ������ ������ �߻��ϴ� ��� �Ʒ��� �ּҷ� �����ϼż� Ȯ���Ͻñ� �ٶ��ϴ�.= */
    /* =   ���� �ּ� : http://testpay.kcp.co.kr/pgsample/FAQ/search_error.jsp       = */
    /* = -------------------------------------------------------------------------- = */
    /* =   Copyright (c)  2010.02   KCP Inc.   All Rights Reserved.                 = */
    /* ============================================================================== */


    /* ============================================================================== */
    /* =   01. ���� ������ �¾� (��ü�� �°� ����)                                  = */
    /* = -------------------------------------------------------------------------- = */
    /* = �� ���� ��                                                                 = */
    /* = * g_conf_key_dir ���� ����                                                 = */
    /* = pub.key ������ ���� ��� ����(���ϸ��� ������ ��η� ����)                 = */
    /* =                                                                            = */
    /* = * g_conf_log_dir ���� ����                                                 = */
    /* = log ���丮 ����                                                          = */
    /* = -------------------------------------------------------------------------- = */

//  String g_conf_home_dir  = "C:\\Tomcat 5.5\\webapps\\ROOT\\2010_ax_hub_windows_jsp";                  // BIN ������ �Է� (bin������) 
//  String g_conf_key_dir   = "C:\\Tomcat 5.5\\webapps\\ROOT\\2010_ax_hub_windows_jsp\\bin\\pub.key";    // ����Ű ���� ������ 
//  String g_conf_log_dir   = "C:\\Tomcat 5.5\\webapps\\ROOT\\2010_ax_hub_windows_jsp\\log";             // LOG ���丮 ������ �Է�


    String g_conf_home_dir  = "C:\\inetpub\\ax_hub_windows_jsp";                  // BIN ������ �Է� (bin������) 
    String g_conf_key_dir   = "C:\\inetpub\\ax_hub_windows_jsp\\bin\\pub.key";    // ����Ű ���� ������ 
    String g_conf_log_dir   = "C:\\inetpub\\ax_hub_windows_jsp\\log";             // LOG ���丮 ������ �Է�


    /* ============================================================================== */
    /* =   02. ���θ� ���� ���� ����                                                = */
    /* = -------------------------------------------------------------------------- = */

    /* = -------------------------------------------------------------------------- = */
    /* =     02-1. ���θ� ���� �ʼ� ���� ����(��ü�� �°� ����)                     = */
    /* = -------------------------------------------------------------------------- = */
    /* = �� ���� ��                                                                 = */
    /* = * g_conf_gw_url ����                                                       = */
    /* =                                                                            = */
    /* = �׽�Ʈ �� : testpaygw.kcp.co.kr�� ������ �ֽʽÿ�.                         = */
    /* = �ǰ��� �� : paygw.kcp.co.kr�� ������ �ֽʽÿ�.                             = */
    /* =																			= */
    /* = * g_conf_js_url ����                                                       = */
    /* = �׽�Ʈ �� : src="http://pay.kcp.co.kr/plugin/payplus_test.js"              = */
    /* =             src="https://pay.kcp.co.kr/plugin/payplus_test.js"             = */
    /* = �ǰ��� �� : src="http://pay.kcp.co.kr/plugin/payplus.js"                   = */
    /* =             src="https://pay.kcp.co.kr/plugin/payplus.js"                  = */
    /* =                                                                            = */
    /* = �׽�Ʈ ��(UTF-8) : src="http://pay.kcp.co.kr/plugin/payplus_test_un.js"    = */
    /* =                    src="https://pay.kcp.co.kr/plugin/payplus_test_un.js"   = */
    /* = �ǰ��� ��(UTF-8) : src="http://pay.kcp.co.kr/plugin/payplus_un.js"         = */
    /* =                    src="https://pay.kcp.co.kr/plugin/payplus_un.js"        = */
    /* =                                                                            = */
    /* =                                                                            = */
    /* = * g_conf_site_cd, g_conf_site_key ����                                     = */
    /* = �ǰ����� KCP���� �߱��� ����Ʈ�ڵ�(site_cd), ����ƮŰ(site_key)�� �ݵ��   = */
    /* =   ������ �ּž� ������ ���������� ����˴ϴ�.                              = */
    /* =                                                                            = */
    /* = �׽�Ʈ �� : ����Ʈ�ڵ�(T0000)�� ����ƮŰ(3grptw1.zW0GSo4PQdaGvsF__)��      = */
    /* =            ������ �ֽʽÿ�.                                                = */
    /* = �ǰ��� �� : �ݵ�� KCP���� �߱��� ����Ʈ�ڵ�(site_cd)�� ����ƮŰ(site_key) = */
    /* =            �� ������ �ֽʽÿ�.                                             = */
    /* =                                                                            = */
    /* =                                                                            = */
    /* = * g_conf_site_name ����                                                    = */
    /* = ����Ʈ�� ����(�ѱ� �Ұ�) : Payplus Plugin���� ������ �� ������ ��ܿ�      = */
    /* =                            ǥ��Ǵ� ���Դϴ�.                              = */
    /* =                            �ݵ�� �����ڷ� �����Ͽ� �ֽñ� �ٶ��ϴ�.       = */
    /* = -------------------------------------------------------------------------- = */

  //String g_conf_gw_url    = "testpaygw.kcp.co.kr";
  //String g_conf_js_url    = "https://pay.kcp.co.kr/plugin/payplus_test.js";
  //String g_conf_site_cd   = "T0000";
  //String g_conf_site_key  = "3grptw1.zW0GSo4PQdaGvsF__";
  //String g_conf_site_name = "KCP TEST SHOP";


    String g_conf_gw_url    = "paygw.kcp.co.kr";
    String g_conf_js_url    = "https://pay.kcp.co.kr/plugin/payplus.js";

    String g_conf_site_cd   = "H4335";
    String g_conf_site_key  = "3beARuPZwB0vFJbsCJ8zc9F__";
    
    String g_conf_site_name = "Amazoncar";
    

    /* ============================================================================== */


    /* = -------------------------------------------------------------------------- = */
    /* =     02-2. ���� ������ �¾� (���� �Ұ�)                                     = */
    /* = -------------------------------------------------------------------------- = */

    String g_conf_gw_port   = "8090";        // ��Ʈ��ȣ(����Ұ�)

    /* ============================================================================== */
%>
