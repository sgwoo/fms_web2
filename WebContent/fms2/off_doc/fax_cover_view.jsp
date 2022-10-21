<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//사용자별 정보 조회 및 수정 페이지
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String br_id = "";
	String br_nm = "";
	String user_nm = "";
	String id = "";
	String user_psd = "";
	String user_cd = "";
	String user_ssn = "";
	String user_ssn1 = "";
	String user_ssn2 = "";
	String dept_id = "";
	String dept_nm = "";
	String user_h_tel = "";
	String user_m_tel = "";
	String user_email = "";
	String user_pos = "";
	String lic_no = "";
	String lic_dt = "";
	String enter_dt = "";
	String user_zip = "";
	String user_addr = "";
	String content = "";
	String filename = "";
	String user_aut2 = "";
	String user_work = "";
	int count = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);
	br_id 		= user_bean.getBr_id();
	br_nm 		= user_bean.getBr_nm();
	user_nm 	= user_bean.getUser_nm();
	id 			= user_bean.getId();
	user_psd 	= user_bean.getUser_psd();
	user_cd 	= user_bean.getUser_cd();
	user_ssn 	= user_bean.getUser_ssn();
	user_ssn1 	= user_bean.getUser_ssn1();
	user_ssn2 	= user_bean.getUser_ssn2();
	dept_id 	= user_bean.getDept_id();
	dept_nm 	= user_bean.getDept_nm();
	user_h_tel 	= user_bean.getUser_h_tel();
	user_m_tel 	= user_bean.getUser_m_tel();
	user_email 	= user_bean.getUser_email();
	user_pos 	= user_bean.getUser_pos();
	user_aut2 	= user_bean.getUser_aut();
	lic_no 		= user_bean.getLic_no();
	lic_dt 		= user_bean.getLic_dt();
	enter_dt 	= user_bean.getEnter_dt();
	content 	= user_bean.getContent();
	filename 	= user_bean.getFilename();
	user_work 	= user_bean.getUser_work();
	
	//본사-영업소
	Hashtable br1 = c_db.getBranch(br_id);
	
	String br_addr 	= String.valueOf(br1.get("BR_ADDR"));
	String br_tel 	= String.valueOf(br1.get("TEL"));
	String br_fax 	= String.valueOf(br1.get("FAX"));
	
	if(dept_nm.equals("고객지원팀")){
		br_tel = "02-392-4242";
		br_fax = "02-3775-4243";
	}
	if(dept_nm.equals("총무팀")){
		br_tel = "02-392-4243";
	}
	
	String s_com_nm 	= request.getParameter("s_com_nm")==null?"":request.getParameter("s_com_nm");
	String s_agnt_nm 	= request.getParameter("s_agnt_nm")==null?"":request.getParameter("s_agnt_nm");
	String s_tel 		= request.getParameter("s_tel")==null?"":request.getParameter("s_tel");
	String s_fax 		= request.getParameter("s_fax")==null?"":request.getParameter("s_fax");
	String b_com_nm 	= request.getParameter("b_com_nm")==null?"":request.getParameter("b_com_nm");
	String b_agnt_nm 	= request.getParameter("b_agnt_nm")==null?"":request.getParameter("b_agnt_nm");
	String b_tel 		= request.getParameter("b_tel")==null?"":request.getParameter("b_tel");
	String b_fax 		= request.getParameter("b_fax")==null?"":request.getParameter("b_fax");
	String cnt 			= request.getParameter("cnt")==null?"":request.getParameter("cnt");
	String dt 			= request.getParameter("dt")==null?"":request.getParameter("dt");
	String title	 	= request.getParameter("title")==null?"":request.getParameter("title");
	String memo		 	= request.getParameter("memo")==null?"":request.getParameter("memo");
	
	String cont = HtmlUtil.htmlBR(memo);
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>FAX커버</title>
<style type=text/css>
<!--
.style1 {font-size: 12px; font-weight: bold;}
-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
</head>
<body topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0 <%if(cmd.equals("print")){%>onLoad="javascript:print(document)"<%}%>>
<center>
<table width=595 border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td><img src=/fms2/off_doc/images/fax_1.gif width=595 height=34></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td align=right>
            <table width=400 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=18 align=right><%=br_addr%></td>
                </tr>
                <tr>
                    <td height=18 align=right>TEL. <%=br_tel%> | FAX. <%=br_fax%> </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=25></td>
    </tr>
    <tr>
        <td>
            <table width=595 border=0 cellpadding=0 cellspacing=2 bgcolor=#000000>
                <tr>
                    <td bgcolor=#FFFFFF>
                        <table width=591 border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td width=78 height=30 align=center bgcolor=dadada><span class=style1>수&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;신</span></td>
                                <td width=217 bgcolor=#FFFFFF  style='font-size:14px;'>&nbsp;&nbsp;<b><%=s_com_nm%></b></td>
                                <td width=1 bgcolor=#000000></td>
                                <td width=78 align=center bgcolor=dadada><span class=style1>발&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;신</span></td>
                                <td width=217 bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=b_com_nm%></b></td>
                            </tr>
                            <tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
                            <tr>
                                <td height=30 align=center bgcolor=dadada><span class=style1>담&nbsp;당&nbsp;자</span></td>
                                <td bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=s_agnt_nm%></b></td>
                                <td width=1 bgcolor=#000000></td>
                                <td align=center bgcolor=dadada><span class=style1>담&nbsp;당&nbsp;자</span></td>
                                <td bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=b_agnt_nm%></b></td>
                            </tr>
                            <tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
                            <tr>
                                <td height=30 align=center bgcolor=dadada><span class=style1>전화번호</span></td>
                                <td bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=s_tel%></b></td>
                                <td width=1 bgcolor=#000000></td>
                                <td align=center bgcolor=dadada><span class=style1>전화번호</span></td>
                                <td bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=b_tel%></b></td>
                            </tr>
                            <tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
                            <tr>
                                <td height=30 align=center bgcolor=dadada><span class=style1>팩스번호</span></td>
                                <td bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=s_fax%></b></td>
                                <td width=1 bgcolor=#000000></td>
                                <td align=center bgcolor=dadada><span class=style1>팩스번호</span></td>
                                <td bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=b_fax%></b></td>
                            </tr>
                            <tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
                            <tr>
                                <td height=30 align=center bgcolor=dadada><span class=style1>총&nbsp;매&nbsp;수</span></td>
                                <td colspan=5 bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=cnt%>매 (표지포함)</b></td>
                            </tr>
                            <tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
                            <tr>
                                <td height=30 align=center bgcolor=dadada><span class=style1>일&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자</span></td>
                                <td colspan=5 bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=dt%></b></td>
                            </tr>
                            <tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
                            <tr>
                                <td height=30 align=center bgcolor=dadada><span class=style1>제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</span></td>
                                <td colspan=5 bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=title%></b></td>
                            </tr>
                        </table>
                    </td>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=25></td>
    </tr>
    <tr>
        <td valign=top background=/fms2/off_doc/images/fax_bg.gif>
            <table width=595 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td><img src=/fms2/off_doc/images/fax_up.gif></td>
                </tr>
                <tr>
                    <td valign=top  height=339>
					  <table width=100% border=0 cellspacing=10 cellpadding=10>
					    <tr>
						  <td style='font-size:14px;'><b><%=cont%></b></td>
						</tr>
					  </table>
					</td>
                </tr>
                <tr>
                    <td valign=bottom><img src=/fms2/off_doc/images/fax_dw.gif></td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr>
        <td colspan=3></td>
    </tr>
    <tr>
        <td height=30 align=center><span class=style1>* 상기 팩스내용에 대해 문의사항이 있으시면 발신자에게 연락주시기 바랍니다.</span></td>
    </tr>
</table>
<script language='javascript'>
<!--
//-->
</script>
</center>
</body>
</html>