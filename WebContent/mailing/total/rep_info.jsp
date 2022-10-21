<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.common.*, acar.user_mng.*, acar.insur.*, acar.car_office.*"%>
<jsp:useBean id="a_db" scope="session" class="acar.cont.AddContDatabase"/>

<%
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String ins_st 	= request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_way 	= request.getParameter("rent_way")==null?"":request.getParameter("rent_way");
	
	if(l_cd.equals("") || l_cd.equals("null")){
		out.println("정상적인 호출이 아닙니다.");	
		return;
	}
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	
	//cont
	ContBaseBean cont = a_db.getCont(m_id, l_cd);
	
	//계약:고객관련
	ContBaseBean base2 = a_db.getContBaseAll(m_id, l_cd);
	
	//담당자정보
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	UsersBean b_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID2")));
	UsersBean b_user2 = b_user;
	UsersBean h_user = u_db.getUsersBean(nm_db.getWorkAuthUser("세금계산서담당자"));
	
	if(String.valueOf(base.get("BUS_ST_NM")).equals("에이전트")){
		b_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID")));
		
		//에이전트 계약진행담당자
		if(!cont.getAgent_emp_id().equals("")){ 
				CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(cont.getAgent_emp_id()); 
				b_user.setUser_m_tel(a_coe_bean.getEmp_m_tel());
				b_user.setUser_nm		(a_coe_bean.getEmp_nm());
		}
	}
	
	InsDatabase ai_db = InsDatabase.getInstance();
	if(ins_st.equals(""))	ins_st = ai_db.getInsSt(String.valueOf(base.get("CAR_MNG_ID")));
	
	//보험정보
	InsurBean ins = ai_db.getInsCase(String.valueOf(base.get("CAR_MNG_ID")), ins_st);
	
	
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>자동차 관리 서비스 안내문</title>
<style type="text/css">
<!--
.style1 {color: #88b228;font-size:13px;font-family:nanumgothic;}
.style2 {color: #747474;font-size:13px;font-family:nanumgothic;}
.style3 {color: #ffffff;font-size:13px;font-family:nanumgothic;}
.style4 {color: #707166; font-weight: bold;font-family:nanumgothic;}
.style5 {color: #e86e1b;font-family:nanumgothic;}
.style6 {color: #385c9d; font-weight: bold;font-family:nanumgothic;}
.style7 {color: #77786b;font-family:nanumgothic;}
.style8 {color: #e60011;font-family:nanumgothic;}
.style9 {color: #707166; font-weight: bold;font-family:nanumgothic;}
.style10 {color: #454545; font-size:8pt;font-family:nanumgothic;}
.style11 {color: #6b930f; font-size:8pt;font-family:nanumgothic;}
.style12 {color: #77786b; font-size:8pt;font-family:nanumgothic;}
.style13 {color: #ff00ff;font-family:nanumgothic;}
.style14 {color: #af2f98; font-size:8pt;font-family:nanumgothic;}
-->
</style>
<link href=http://fms1.amazoncar.co.kr/acar/main_car_hp/style.css rel=stylesheet type=text/css>
</head>
<body topmargin=0 leftmargin=0 bgcolor=#eef0dc>
<br><br><br><br>
<table width=835 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/total/images/tt_bg.gif align=center>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_up.gif width=835 height=55></td>
    </tr>
    <tr>
        <td align=center>
        	<table width=736 border=0 cellspacing=0 cellpadding=0>
	            <tr>
	                <td>
		                <table width=736 border=0 cellspacing=0 cellpadding=0>
		                    <tr>
		                        <td width=505 valign=top><img src=https://fms5.amazoncar.co.kr/mailing/total/images/total_stitle.gif><br><br>
		                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style1><b>[ <%=base.get("FIRM_NM")%> ]</b></span>&nbsp;<span class=style2>님</span> </span></td>
		                        <td width=231>
			                        <table width=231 border=0 cellspacing=0 cellpadding=0>
			                        	<tr>
			                        		<td colspan=2 height=12></td>
			                        	</tr>
			                            <tr>
			                                <td width=75><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_sup_bsn.gif width=68 height=18></td>
			                                <td><span class=style2><strong><%=b_user.getUser_nm()%> <%=b_user.getUser_m_tel()%></strong></span></td>
			                  			</tr>
			                  			<tr>
			                        		<td colspan=2 height=2></td>
			                        	</tr>
			                            <tr>
			                                <td><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_sup_mng.gif width=68 height=18></td>
			                                <td><span class=style2><strong><%=b_user2.getUser_nm()%> <%=b_user2.getUser_m_tel()%></strong></span></td>
			                       		</tr>
			                       		<tr>
			                        		<td colspan=2 height=2></td>
			                        	</tr>
			                            <tr>
			                                <td><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_sup_acct.gif width=68 height=18></td>
			                                <td><span class=style2><strong><%=h_user.getUser_nm()%> <%=h_user.getHot_tel()%></strong></span></td>
			                     		</tr>
			                        </table>
			                    </td>
		                    </tr>
		                </table>
		            </td>
	        	</tr>
	            <tr>
	                <td height=25 align=center></td>
	      		</tr>
	            <tr>
	                <td>
		                <table width=736 border=0 cellspacing=0 cellpadding=0>
		                    <tr>
		                        <td width=184><a href="http://fms1.amazoncar.co.kr/mailing/total/scd_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_scd_gr.gif border=0></a></td>
		                        <td width=184><a href="http://fms1.amazoncar.co.kr/mailing/total/fms_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_cfms_gr.gif border=0></a></td>
		                        <td width=184><a href="http://fms1.amazoncar.co.kr/mailing/total/car_mng_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_car_gr.gif border=0></a></td>
		                        <td width=184><a href="http://fms1.amazoncar.co.kr/mailing/total/rep_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_rep.gif border=0></a></td>
		                    </tr>
		                </table>
		            </td>
	            </tr>
	            <tr>
	            	<td height=15></td>
	            </tr>
	            <tr>
	                <td align=center>
	                	<table width=683 border=0 cellspacing=0 cellpadding=0>
		                    <tr>
		                        <td width=567 style="line-height:18px;"><span class=style2>당사는 대여자동차의 원할한 정비/관리를 위해서 <font color=red><b>스피드메이트</b></font>(SK네트웍스)를 지정정비 협력업체로 운영하고 있습니다. 지정정비업체 방문전에 관리담당자와 먼저 통화하시면 좀 더 빠른 서비스와 안내를 받으실 수 있습니다.</span></td>
		                        <td>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_rep_img.gif></td>
		                    </tr>
	                	</table>
	               	</td>
	            </tr>
	            <tr>
	            	<td height=20></td>
	            </tr>
	            <tr>
	                <td align=center><img src=https://fms5.amazoncar.co.kr/mailing/total/images/rep_bar_img.gif usemap="#Map" border=0></td>
	            </tr>
	            <map name="Map">
				    <area shape="rect" coords="412,196,482,177" href="javascript:var win=window.open('https://fms.amazoncar.co.kr/service/popup/speedmate.jsp','speed','left=50, top=50, width=717, height=700, status=no, scrollbars=yes, resizable=no');">
				</map>
	            <tr>
	            	<td height=60></td>
	            </tr>
	            <tr>
	                <td align=center>
	                	<table width=700 border=0 cellspacing=0 cellpadding=0>
			                <tr>
			                    <td width=35>&nbsp;</td>
			                    <td width=92><img src=https://fms5.amazoncar.co.kr/acar/images/logo_1.png></td>
			                    <td width=35>&nbsp;</td>
			                    <td width=1 bgcolor=dbdbdb></td>
			                    <td width=40>&nbsp;</td>
			                    <td width=499><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
			                </tr>
			                <map name=Map1>
			                    <area shape=rect coords=283,53,403,67 href=mailto:webmaster@amazoncar.co.kr>
			                </map>
			            </table>
	                </td>
	            </tr>
			</table>
		</td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_dw.gif width=835 height=55></td>
    </tr>
</table>
<br><br><br><br>
</body>
</html>