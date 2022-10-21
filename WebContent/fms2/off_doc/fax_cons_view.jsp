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
<table width=640 border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td><img src=/fms2/off_doc/images/fax01_1.gif></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td align=right>
            <table width=640 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=18 align=right><%=br_addr%></td>
                </tr>
                <tr>
                    <td height=18 align=right>TEL. <%=br_tel%> &nbsp;|&nbsp; FAX. <%=br_fax%> </td>
                </tr>
                <tr>
                    <td align=right style='font-size:11px'><b>http://www.amazoncar.co.kr</b></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10></td>
    </tr>
    <tr>
        <td align=right>
            <table width=640 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td colspan=7>
                        <table width=640 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=40 style='font-size:14px;'>&nbsp;&nbsp;<b><%=s_com_nm%> 님 귀하</b></td>
                                <td align=right valign=bottom><b><%=dt%></b></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan=7 height=2 bgcolor=#000000></td>
                </tr>
                <tr>
                    <td height=15></td>
                </tr>
                <tr>
                    <td width=85 align=center height=24><span class=style1>담&nbsp; 당&nbsp;자</span></td>
                    <td width=15><img src=/fms2/off_doc/images/fax01_3.gif align=absmiddle></td>
                    <td width=214 style='font-size:14px;'><b><%=s_agnt_nm%></b></td>
                    <td width=12>&nbsp;</td>
                    <td width=85 align=center><span class=style1>발&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;신</span></td>
                    <td width=15><img src=/fms2/off_doc/images/fax01_3.gif align=absmiddle></td>
                    <td width=214 style='font-size:14px;'><b><%=b_com_nm%></b></td>
                </tr>
                <tr>
                    <td align=center height=24><span class=style1>전화번호</span></td>
                    <td><img src=/fms2/off_doc/images/fax01_3.gif align=absmiddle></td>
                    <td style='font-size:14px;'><b><%=s_tel%></b></td>
                    <td>&nbsp;</td>
                    <td align=center><span class=style1>담&nbsp; 당&nbsp;자</span></td>
                    <td><img src=/fms2/off_doc/images/fax01_3.gif align=absmiddle></td>
                    <td style='font-size:14px;'><b><%=b_agnt_nm%></b></td>
                </tr>
                <tr>
                    <td align=center height=24><span class=style1>팩스번호</span></td>
                    <td><img src=/fms2/off_doc/images/fax01_3.gif align=absmiddle></td>
                    <td style='font-size:14px;'><b><%=s_fax%></b></td>
                    <td>&nbsp;</td>
                    <td align=center><span class=style1>전화번호</span></td>
                    <td><img src=/fms2/off_doc/images/fax01_3.gif align=absmiddle></td>                    
                    <td style='font-size:14px;'><b><%=b_tel%></b></td>
                </tr>
                <tr>
                    <td align=center height=24><span class=style1>총&nbsp; 매&nbsp;수</span></td>
                    <td><img src=/fms2/off_doc/images/fax01_3.gif align=absmiddle></td>
                    <td style='font-size:14px;'><b><%=cnt%>매 (표지포함)</b></td>
                    <td>&nbsp;</td>
                    <td align=center><span class=style1>팩스번호</span></td>
                    <td><img src=/fms2/off_doc/images/fax01_3.gif align=absmiddle></td>
                    <td style='font-size:14px;'><b><%=b_fax%></b></td>
                </tr>
                <tr>
                    <td height=13></td>
                </tr>
                <tr>
                    <td colspan=7 height=1 bgcolor=#000000></td>
                </tr>
                <tr>
                    <td colspan=7 height=40 align=absmiddle style='font-size:14px'>&nbsp;&nbsp;<img src=/fms2/off_doc/images/fax01_4.gif>&nbsp;&nbsp;<b>과태료·통행료·주차요금 영수증 발급기관 안내</b></td>
                </tr>
                <tr>
                    <td colspan=7 height=2 bgcolor=#000000></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=40></td>
    </tr>
    <tr>
        <td valign=top align=center>
            <table width=620 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td valign=top>&nbsp;고객님께서 미처 납부 못한 과태료(자동차운행관련), 유료도로통행료, 주차요금 등은 당사가 고객님을 대신해 선<br>
                      &nbsp;납부하고 고객님께 청구하고 있습니다. 당사에 납부했거나 예정인 비용의 증빙이 필요하신 경우 <b>고지서를 참조<br>
                      &nbsp;하시거나 아래의 연락처로 요청</b>하시면 납부기관이 발행한 증빙을 받아보실 수 있습니다.
                    </td>
                </tr>
                <tr>
		     		<td align=center>
			          	<table width=340 border=0 cellspacing=0 cellpadding=0>
			           		<tr>
			              		<td height=40></td>
			           		</tr>
							<tr>
								<td width=190 height=30><span class=style1>· 한국도로공사</span></td>
								<td width=150><span class=style1>031)426-1281</span></td>
							</tr>
							<tr>
						   		<td height=30><span class=style1>· 제삼경인고속도로</span></td>
								<td><span class=style1>031)8084-8947~8</span></td>
							</tr>
							<tr>
								<td height=26><span class=style1>· 서울고속도로 주식회사</span></td>
								<td>&nbsp;</td>
							</tr>
							<tr>
						  		<td height=20>&nbsp;&nbsp;&nbsp;<span class=style1>통일로영업소</span></td>
						    	<td><span class=style1>031)994-6400~1</span></td>
							</tr>
							<tr>
						   		<td height=20>&nbsp;&nbsp;&nbsp;<span class=style1>양주영업소</span></td>
						 		<td><span class=style1>031)894-6300~1</span></td>
							</tr>
							<tr>
						  		<td height=20>&nbsp;&nbsp;&nbsp;<span class=style1>불암산영업소</span></td>
						   		<td><span class=style1>031)522-6300~1</span></td>
							</tr>
							<tr>
						    	<td height=20>&nbsp;&nbsp;&nbsp;<span class=style1>송추영업소</span></td>
						    	<td><span class=style1>031)894-6200~1</span></td>
							</tr>
							<tr>
						    	<td height=20>&nbsp;&nbsp;&nbsp;<span class=style1>고양영업소</span></td>
						 		<td><span class=style1>031)994-6300~1</span></td>
							</tr>
							<tr>
								<td height=30><span class=style1>· 경기도 건설본부</span></td>
								<td><span class=style1>031)429-6067~8</span></td>
							</tr>
							<tr>
						 		<td height=30><span class=style1>· 신공항하이웨이(주)</span></td>
						 		<td><span class=style1>032)560-6205</span></td>
							</tr>

							<tr>
								<td height=30><span class=style1>· 경수고속도로</span></td>
						 		<td><span class=style1>070-7435-9041</span></td>
							</tr>
							<tr>
						   		<td height=30><span class=style1>· 인천대교(주)</span></td>
								<td><span class=style1>032)745-8200,8058</span></td>
							</tr>
							<tr>
						 		<td height=30><span class=style1>· GK 해상도로주식회사</span></td>
						   		<td><span class=style1>1644-0082</span></td>
							</tr>
							<tr>
						  		<td height=30><span class=style1>· 수석 호평 도시고속도로</span></td>
								<td><span class=style1>031)511-7676</span></td>
							</tr>
							<tr>
						    	<td height=30><span class=style1>· 부천시시설관리공단이사장</span></td>
						  		<td><span class=style1>032)340-0902,0932,0952</span></td>
							</tr>
							<tr>
						   		<td height=30><span class=style1>· 고양도시관리공사</span></td>
						     	<td><span class=style1>031)929-4848</span></td>
							</tr>
							<tr>
						  		<td height=30><span class=style1>· 부산시설공단 광안대로사업단</span></td>
						    	<td><span class=style1>051)780-0078~9</span></td>
							</tr>
							<tr>
						   		<td height=30><span class=style1>· 안양시 시설관리공단</span></td>
						 		<td><span class=style1>031)389-5327,5329,5334</span></td>
							</tr>
						 	<tr>
								<td height=15></td>
							</tr>			                             			
			       		</table>
			   		</td>
		  		</tr>
                <tr>
                    <td height=30 colspan=3></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
  		<td height=30 style='font-size:12px;' align=center><b>* 상기 팩스내용에 대해 문의사항이 있으시면 발신자에게 연락주시기 바랍니다.</b></td>
	</tr>
</table>
<!--

<table width=595 border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td height=60></td>
    </tr>
    <tr>
        <td><img src=/fms2/off_doc/images/fax_1.gif width=595 height=34></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td align=right>
            <table width=300 border=0 cellspacing=0 cellpadding=0>
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
        <td height=379 valign=top background=/fms2/off_doc/images/fax_3.gif>
            <table width=595 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=60 colspan=3></td>
                </tr>
                <tr>
                    <td>
					  <table width=100% border=0 cellspacing=20 cellpadding=20>
					    <tr>
						  <td style='font-size:14px;'><b><%=cont%></b></td>
						</tr>
					  </table>
					</td>
                </tr>
                <tr>
                    <td colspan=3></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=30 align=center><span class=style1>* 상기 팩스내용에 대해 문의사항이 있으시면 발신자에게 연락주시기 바랍니다.</span></td>
    </tr>
</table>-->
<script language='javascript'>
<!--
//-->
</script>
</center>
</body>
</html>