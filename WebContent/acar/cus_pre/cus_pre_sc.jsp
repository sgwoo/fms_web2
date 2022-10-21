<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_pre.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	float cm_rate = 0.0f;
	float cd_rate = 0.0f;
	float rm_rate = 0.0f;
	float rd_rate = 0.0f;
		
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "03", "01", "01");
	
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	
	if  ( !user_nm.equals("전체") ) {
		Hashtable id = c_db.getDamdang_id(user_nm);
		user_id = String.valueOf(id.get("USER_ID"));
	} else {
	          user_id = "";
	}
	
	CusPre_Database cp_db = CusPre_Database.getInstance();
	int[] st = cp_db.getCusPre(user_id);
	int[] client = cp_db.getCusPre_client(user_id);
	int[] car = cp_db.getCusPre_car(user_id);

	if(client[0]!=0)	cm_rate = (float)(client[2]*100/client[0]);
	if(client[3]!=0)	cd_rate = client[5]*100/(float)client[3];
	if(car[0]!=0)		rm_rate = car[2]*100/(float)car[0];
	if(car[3]!=0)		rd_rate = car[5]*100/(float)car[3];

	
	
	//영업소 리스트 조회
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();
	for(int i=0; i<brch_size; i++){
		Hashtable branch = (Hashtable)branches.elementAt(i);
	}
		
	Vector users = c_db.getUserList("", "", "BUS_MNG_EMP"); //영업_고객지원팀 리스트
	int user_size= users.size();
	for(int i=0; i<user_size; i++){
		Hashtable user = (Hashtable)users.elementAt(i);
	}
	
			//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>

<html>
<head>
<title>:: FMS ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
			
-->
</script>
</head>

<body><a name="top"></a>
<form name='form1' method='post' action=''>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td colspan="3"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>관리현황</span></td>
    </tr>
    <tr> 
        <td width=47% align="center" class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
      	      	<tr><td class=line2 style='height:1'></td></tr>
                <tr> 
                    <td width=23% rowspan="3" align="center" class='title'>거래처</td>
                    <td width=23% class='title' align="center">단독관리</td>
                    <td width=54% align="center"> <a href="#"><%= st[0] %> 건</a></td>
                </tr>
                <tr> 
                    <td class='title' align="center">공동관리</td>
                    <td align="center"><a href="#"><%= st[1] %> 건</a></td>
                </tr>
                <tr> 
                    <td class='title' align="center">합계</td>
                    <td align="center"><a href="#"><%= st[0]+st[1] %> 건</a></td>
                </tr>
            </table>
        </td>
        <td width=6% align="center">&nbsp;</td>
        <td width=47% align="center" class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
      	      	<tr><td class=line2 style='height:1'></td></tr>
                <tr> 
                    <td width=23% rowspan="3" align="center" class='title'>자동차</td>
                    <td width=23% class='title' align="center">단독관리</td>
                    <td width=54% align="center"><a href="#"><%= st[2] %> 대</a></td>
                </tr>
                <tr> 
                    <td class='title' align="center">공동관리</td>
                    <td align="center"><a href="#"><%= st[3] %> 대</a></td>
                </tr>
                <tr> 
                    <td class='title' align="center">합계</td>
                    <td align="center"><a href="#"><%= st[2]+st[3] %> 대</a></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="3" align="center">&nbsp;</td>
    </tr>
    <tr align="center"> 
        <td colspan="3"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td class=line width="60%"> 
                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                    	    <tr><td class=line2 style='height:1'></td></tr>
                            <tr> 
                                <td width=19% class=title>구분</td>
                                <td width=18% class=title>일반식</td>
                                <td width=18% class=title>기본식</td>
                                <td width=18% class=title>맞춤식</td>
                                <td width=27% class=title>합계</td>
                            </tr>
                            <tr> 
                                <td class=title>리스</td>
                                <td align="center"><a href="#"><%= st[7] %> 대</a></td>
                                <td align="center"><a href="#"><%= st[8] %> 대</a></td>
                                <td align="center"><a href="#"><%= st[9] %> 대</a></td>
                                <td align="center"><a href="#"><%= st[7]+st[8]+st[9] %> 대</a></td>
                            </tr>
                            <tr> 
                                <td class=title>렌트</td>
                                <td align="center"><a href="#"><%= st[4] %> 대</a></td>
                                <td align="center"><a href="#"><%= st[5] %> 대</a></td>
                                <td align="center"><a href="#"><%= st[6] %> 대</a></td>
                                <td align="center"><a href="#"><%= st[4]+st[5]+st[6] %> 대</a></td>
                            </tr>
                            <tr> 
                                <td class=title>합계</td>
                                <td align="center"><a href="#"><%= st[4]+st[7] %> 대</a></td>
                                <td align="center"><a href="#"><%= st[5]+st[8] %> 대</a></td>
                                <td align="center"><a href="#"><%= st[6]+st[9] %> 대</a></td>
                                <td align="center"><a href="#"><%= st[4]+st[5]+st[6]+st[7]+st[8]+st[9] %> 대</a></td>
                            </tr>
                        </table>
                    </td>
                    <td width=6%>&nbsp;</td>
                    <td width="34%" class=line> 
                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                    	    <tr><td class=line2 style='height:1'></td></tr>
                            <tr> 
                                <td class=title width=30%>구분</td>
                                <td class=title width=70%>대수</td>
                            </tr>
                            <tr> 
                                <td class=title>최초영업</td>
                                <td align="center"><a href="#"><%= st[10] %> 대</a></td>
                            </tr>
                            <tr> 
                                <td class=title>영업담당</td>
                                <td align="center"><a href="#"><%= st[11] %> 대</a></td>
                            </tr>
                            <tr> 
                                <td class=title>관리담당</td>
                                <td align="center"><a href="#"><%= st[12] %> 대</a></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td colspan=3><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>업무추진현황</span></td>
    </tr>
    <tr> 
        <td colspan="3"  class='line' > 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
      	      	<tr><td class=line2 style='height:1'></td></tr>
                <tr align="center"> 
                    <td colspan="2" class=title>거래처방문</td>
                    <td colspan="2" class=title>자동차관리</td>
                </tr>
                <tr align="center"> 
                    <td width=25% class=title>당월</td>
                    <td width=25% class=title>당일</td>
                    <td width=25% class=title>당월</td>
                    <td width=25% class=title>당일</td>
                </tr>
                <tr> 
                    <td> 
                        <table width="180" border="0" cellspacing="0" cellpadding="0" align="center">
                            <tr> 
                                <td width="15">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="30">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="30">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="30">&nbsp;</td>
                                <td width="15">&nbsp;</td>
                            </tr>
                            <tr> 
                                <td style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid" height="120" valign="top"> 
                                    <br> <font size="1">100</font> </td>
                                <td>&nbsp;</td>
                                <td valign="bottom"> 
                                    <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                                        <tr> 
                                            <td height="20" valign="bottom" align="center"><a href="#"><%= st[0]+st[1] %>건</a></td>
                                        </tr>
                                        <tr> 
                                            <td valign="bottom" height="100"><img src=/images/menu_back2.gif width=30 height=<%= 100-(100-(st[0]+st[1])) %>></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>&nbsp;</td>
                                <td valign="bottom"> 
                                    <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                                        <tr> 
                                            <td height="19" valign="bottom" align="center"><a href="#"><%= client[1] %>건</a></td>
                                        </tr>
                                        <tr> 
                                            <td valign="bottom" height="81"><img src=/images/menu_back.gif width=30 height=<%= 100-(100-client[1]) %>></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>&nbsp;</td>
                                <td valign="bottom"> 
                                    <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                                        <tr> 
                                            <td height="68" valign="bottom" align="center"><a href="#"><%= client[2] %>건</a></td>
                                        </tr>
                                        <tr> 
                                            <td height="32" valign="bottom"><img src=/images/result1.gif width=30 height=<%= 100-(100-client[2]) %>></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr> 
                                <td>&nbsp;</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">전체</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">예정</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">실시</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                            </tr>
                            <tr> 
                                <td align="center">&nbsp;</td>
                                <td colspan="7" align="center"><font color="#999900">실시율 <%= AddUtil.parseFloatCipher(cm_rate,2) %>%</font></td>
                            </tr>
                        </table>
                    </td>
                    <td> 
                        <table width="180" border="0" cellspacing="0" cellpadding="0" align="center">
                            <tr> 
                                <td width="15">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="30">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="30">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="30">&nbsp;</td>
                                <td width="15">&nbsp;</td>
                            </tr>
                            <tr> 
                                <td style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid" height="120" valign="top"> 
                                <br> <font size="1">100</font> </td>
                                <td>&nbsp;</td>
                                <td valign="bottom"> 
                                    <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                                        <tr> 
                                            <td height="20" valign="bottom" align="center"><a href="#"><%= st[0]+st[1] %>건</a></td>
                                        </tr>
                                        <tr> 
                                            <td valign="bottom" height="100"><img src=/images/menu_back2.gif width=30 height=<%= 100-(100-(st[0]+st[1])) %>></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>&nbsp;</td>
                                <td valign="bottom"> 
                                    <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                                        <tr> 
                                            <td height="19" valign="bottom" align="center"><a href="#"><%= client[4] %>건</a></td>
                                        </tr>
                                        <tr> 
                                            <td valign="bottom" height="81"><img src=/images/menu_back.gif width=30 height=<%= 100-(100-client[4]) %>></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>&nbsp;</td>
                                <td valign="bottom"> 
                                    <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                                        <tr> 
                                            <td height="68" valign="bottom" align="center"><a href="#"><%= client[5] %>건</a></td>
                                        </tr>
                                        <tr> 
                                            <td height="32" valign="bottom"><img src=/images/result1.gif width=30 height=<%= 100-(100-client[5]) %>></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr> 
                                <td>&nbsp;</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">전체</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">예정</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">실시</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                            </tr>
                            <tr> 
                                <td align="center">&nbsp;</td>
                                <td colspan="7" align="center"><font color="#999900">실시율 <%= AddUtil.parseFloatCipher(cd_rate,2) %>%</font></td>
                            </tr>
                        </table>
                    </td>
                    <td> 
                        <table width="180" border="0" cellspacing="0" cellpadding="0" align="center">
                            <tr> 
                                <td width="15">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="30">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="30">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="30">&nbsp;</td>
                                <td width="15">&nbsp;</td>
                            </tr>
                            <tr> 
                                <td style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid" height="120" valign="top"> 
                                <br> <font size="1">100</font> </td>
                                <td>&nbsp;</td>
                                <td valign="bottom"> 
                                    <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                                        <tr> 
                                            <td height="20" valign="bottom" align="center"><a href="#"><%= st[2]+st[3] %>건</a></td>
                                        </tr>
                                        <tr> 
                                            <td valign="bottom" height="100"><img src=/images/menu_back2.gif width=30 height=<%= 100-(100-(st[2]+st[3])) %>></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>&nbsp;</td>
                                <td valign="bottom"> 
                                    <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                                        <tr> 
                                            <td height="19" valign="bottom" align="center"><a href="#"><%= car[1] %>건</a></td>
                                        </tr>
                                        <tr> 
                                            <td valign="bottom" height="81"><img src=/images/menu_back.gif width=30 height=<%= 100-(100-car[1]) %>></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>&nbsp;</td>
                                <td valign="bottom"> 
                                    <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                                        <tr> 
                                            <td height="68" valign="bottom" align="center"><a href="#"><%= car[2] %>건</a></td>
                                        </tr>
                                        <tr> 
                                            <td height="32" valign="bottom"><img src=/images/result1.gif width=30 height=<%= 100-(100-car[2]) %>></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr> 
                                <td>&nbsp;</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">전체</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">예정</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">실시</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                            </tr>
                            <tr> 
                                <td align="center">&nbsp;</td>
                                <td colspan="7" align="center"><font color="#999900">실시율 <%= AddUtil.parseFloatCipher(rm_rate,2) %>%</font></td>
                            </tr>
                        </table>
                    </td>
                    <td> 
                        <table width="180" border="0" cellspacing="0" cellpadding="0" align="center">
                            <tr> 
                                <td width="15">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="30">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="30">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="30">&nbsp;</td>
                                <td width="15">&nbsp;</td>
                            </tr>
                            <tr> 
                                <td style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid" height="120" valign="top"> 
                                <br> <font size="1">100</font> </td>
                                <td>&nbsp;</td>
                                <td valign="bottom"> 
                                    <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                                        <tr> 
                                            <td height="20" valign="bottom" align="center"><a href="#"><%= st[2]+st[3] %>건</a></td>
                                        </tr>
                                        <tr> 
                                            <td valign="bottom" height="100"><img src=/images/menu_back2.gif width=30 height=<%= 100-(100-(st[2]+st[3])) %>></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>&nbsp;</td>
                                <td valign="bottom"> 
                                    <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                                        <tr> 
                                            <td height="19" valign="bottom" align="center"><a href="#"><%= car[4] %>건</a></td>
                                        </tr>
                                        <tr> 
                                            <td valign="bottom" height="81"><img src=/images/menu_back.gif width=30 height=<%= 100-(100-car[4]) %>></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>&nbsp;</td>
                                <td valign="bottom"> 
                                    <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                                        <tr> 
                                            <td height="68" valign="bottom" align="center"><a href="#"><%= car[5] %>건</a></td>
                                        </tr>
                                        <tr> 
                                            <td height="32" valign="bottom"><img src=/images/result1.gif width=30 height=<%= 100-(100-car[5]) %>></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr> 
                                <td>&nbsp;</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">전체</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">예정</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">실시</td>
                                <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                            </tr>
                            <tr> 
                                <td align="center">&nbsp;</td>
                                <td colspan="7" align="center"><font color="#999900">실시율 <%= AddUtil.parseFloatCipher(rd_rate,2) %>%</font></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
</table>
</form>
</body>
</html>

