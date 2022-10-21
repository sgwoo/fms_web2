<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.insur.*, acar.car_office.*"%>
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
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>자동차 관리 서비스 안내문</title>
<style type="text/css">
<!--
.style1 {color: #88b228;font-size:13px;}
.style2 {color: #333333;font-size:13px;}
.style3 {color: #ffffff}
.style4 {color: #707166; font-weight: bold;}
.style5 {color: #e86e1b}
.style6 {color: #385c9d; font-weight: bold;}
.style7 {color: #77786b}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:8pt;}
.style13 {color: #ff00ff}
.style14 {color: #af2f98; font-size:8pt;}
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
			                                <td><span class=style2><%=b_user.getUser_nm()%> <%=b_user.getUser_m_tel()%></span></td>
			                  			</tr>
			                  			<tr>
			                        		<td colspan=2 height=2></td>
			                        	</tr>
			                            <tr>
			                                <td><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_sup_mng.gif width=68 height=18></td>
			                                <td><span class=style2><%=b_user2.getUser_nm()%> <%=b_user2.getUser_m_tel()%></span></td>
			                       		</tr>
			                       		<tr>
			                        		<td colspan=2 height=2></td>
			                        	</tr>
			                            <tr>
			                                <td><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_sup_acct.gif width=68 height=18></td>
			                                <td><span class=style2><%=h_user.getUser_nm()%> <%=h_user.getHot_tel()%></span></td>
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
		                	<%if(String.valueOf(base.get("RENT_WAY")).equals("기본식")){%><!--기본식일경우-->
		                	<tr>
		                		<td width=184><a href=http://fms1.amazoncar.co.kr/mailing/total/scd_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_gscd_gr.gif width=184 height=32 border=0></a></td>
		                		<td width=184><a href=http://fms1.amazoncar.co.kr/mailing/total/fms_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_gcfms_gr.gif width=184 height=32 border=0></a></td>
		                		<td width=184><a href=http://fms1.amazoncar.co.kr/mailing/total/car_mng_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_gcar_gr.gif width=184 height=32 border=0></a></td>
		                        <td width=184><!--<img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_gfee.gif width=184 height=32 border=0>--></td>
		                	</tr>
							<%}else{%>
		                    <tr>
		                        <td width=148><a href="http://fms1.amazoncar.co.kr/mailing/total/scd_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_scd_gr.gif width=148 height=32 border=0></a></td>
		                        <td width=147><a href="http://fms1.amazoncar.co.kr/mailing/total/fms_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_cfms_gr.gif width=147 height=32 border=0></a></td>
		                        <td width=147><a href="http://fms1.amazoncar.co.kr/mailing/total/car_mng_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_car_gr.gif width=147 height=32 border=0></a></td>
		                        
		                        <td width=147><a href="http://fms1.amazoncar.co.kr/mailing/total/rep_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_rep_gr.gif width=147 height=32 border=0></a></td>
		                    <td width=147><!--<a href="http://fms1.amazoncar.co.kr/mailing/total/fee_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_fee.gif width=147 height=32 border=0></a>--></td>
		                    </tr>
							<%}%>
		                </table>
		            </td>
	            </tr>
	            <tr>
	            	<td height=15></td>
	            </tr>
	            <tr>
	                <td align=center>
	                	<table width=633 border=0 cellspacing=0 cellpadding=0>
		                    <tr>
		                        <td width=567 style="line-height:18px;"><span class=style2>고속도로 및 유료도로 또는 유료주차장을 이용하면서 본의아니게 통행료 또는 주차료를<br>
		                        미납하거나 일부 금액을 지불하지 못한 경우, 당사는 고객님의 편의와 고객정보의 보호를<br>위해서 아래와 같이 업무를 처리합니다.</span></td>
		                        <td><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_fee_img.gif>&nbsp;</td>
		                    </tr>
	                	</table>
	               	</td>
	            </tr>
	            <tr>
	            	<td height=20></td>
	            </tr>
	            <tr>
	                <td align=center><img src=https://fms5.amazoncar.co.kr/mailing/total/images/fee_bar_img.gif></td>
	            </tr>
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
			                    <td width=499><img src=https://fms5.amazoncar.co.kr/mailing/total/images/bottom_esti_right.gif border=0></td>
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