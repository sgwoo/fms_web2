<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, cust.member.*, acar.user_mng.*, acar.car_office.*"%>
<jsp:useBean id="a_db" scope="session" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>

<%
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_st 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
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
	
	String r_client_id = String.valueOf(base.get("CLIENT_ID"));
	
		// 고객 fms id, pwd
	MemberBean  member = m_db.getMemberCase(r_client_id, "", "");
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>자동차 관리 서비스 안내문</title>
<style type="text/css">
<!--
.style1 {color: #88b228;font-size:13px;font-family:nanumgothic;}
.style2 {color: #333333;font-size:13px;font-family:nanumgothic;}
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
<script language="JavaScript" type="text/JavaScript">
<!-- 
     function ViewLayer(){
        //만일 Pop라는 녀석이 닫혀있다면??
        if(document.getElementById("layer1").style.display=="none"){
           //열어주어라
           document.getElementById("layer1").style.display='inline'
        //그렇지 않은 모든 경우라면??
        }else{
           //닫아주어라
           document.getElementById("layer1").style.display='none'
        }
     }
	 function hidden(){
               document.all.layer1.style.display = "none";
			   }
			   
    function ViewLayer2(){
        if(document.getElementById("layer2").style.display=="none"){
           document.getElementById("layer2").style.display='inline'
        }else{
           document.getElementById("layer2").style.display='none'
        }
     }
	 function hidden2(){
               document.all.layer2.style.display = "none";
			   }
			   
	 function ViewLayer3(){
        if(document.getElementById("layer3").style.display=="none"){
           document.getElementById("layer3").style.display='inline'
        }else{
           document.getElementById("layer3").style.display='none'
        }
     }
	 function hidden3(){
               document.all.layer3.style.display = "none";
			   }
			   
	function ViewLayer4(){
        if(document.getElementById("layer4").style.display=="none"){
           document.getElementById("layer4").style.display='inline'
        }else{
           document.getElementById("layer4").style.display='none'
        }
     }
	 function hidden4(){
               document.all.layer4.style.display = "none";
			   }
			   
	function ViewLayer5(){
        if(document.getElementById("layer5").style.display=="none"){
           document.getElementById("layer5").style.display='inline'
        }else{
           document.getElementById("layer5").style.display='none'
        }
     }
	 function hidden5(){
               document.all.layer5.style.display = "none";
			   }
			   
	function ViewLayer6(){
        if(document.getElementById("layer6").style.display=="none"){
           document.getElementById("layer6").style.display='inline'
        }else{
           document.getElementById("layer6").style.display='none'
        }
     }
	 function hidden6(){
               document.all.layer6.style.display = "none";
			   }
			   
	function ViewLayer7(){
        if(document.getElementById("layer7").style.display=="none"){
           document.getElementById("layer7").style.display='inline'
        }else{
           document.getElementById("layer7").style.display='none'
        }
     }
	 function hidden7(){
               document.all.layer7.style.display = "none";
			   }
			   
	function ViewLayer8(){
        if(document.getElementById("layer8").style.display=="none"){
           document.getElementById("layer8").style.display='inline'
        }else{
           document.getElementById("layer8").style.display='none'
        }
     }
	 function hidden8(){
               document.all.layer8.style.display = "none";
			   }
			   
			   
			   
//-->			   
</script> 


<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>
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
		                		<td width=245><a href=http://fms1.amazoncar.co.kr/mailing/total/scd_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_gscd_gr.gif border=0></a></td>
		                		<td width=245><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_gcfms.gif border=0></td>
		                		<td width=245><a href=http://fms1.amazoncar.co.kr/mailing/total/car_mng_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_gcar_gr.gif border=0></a></td>
		                	</tr>
							<%}else{%>
		                    <tr>
		                        <td width=184><a href="http://fms1.amazoncar.co.kr/mailing/total/scd_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_scd_gr.gif border=0></a></td>
		                        <td width=184><a href="http://fms1.amazoncar.co.kr/mailing/total/fms_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_cfms.gif border=0></a></td>
		                        <td width=184><a href="http://fms1.amazoncar.co.kr/mailing/total/car_mng_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_car_gr.gif border=0></a></td>
		                        <td width=184><a href="http://fms1.amazoncar.co.kr/mailing/total/rep_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_rep_gr.gif border=0></a></td>
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
	                	<table width=683 border=0 cellspacing=0 cellpadding=0>
		                    <tr>
		                        <td width=567 style="line-height:18px;"><span class=style2><span class=style13><b>FMS(Fleet Management System)</b></span>는 아마존카가 자체적으로 개발한 차량관리 토탈
		            			솔루션으로 인터넷을 통해 실시간으로 고객님의 차량관리 정보확인 및 회계업무를 쉽게 처리하실 수 있도록
		            			고안된 프로그램입니다. 큰 의미로는 차량관리경영 시스템이지만, 당사 직원과 고객간의 커뮤니
		            			케이션을 대신할 수 있는 창구역할의 기능을 수행하게 될 것입니다.</span></td>
		                        <td>&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_cfms_img.gif>&nbsp;</td>
		                    </tr>
	                	</table>
	               	</td>
	            </tr>
	            
	            <tr>
	                <td align=center>
	                	<table width=683 border=0 cellspacing=0 cellpadding=0>
		                    <tr>
		                        <td height=24 valign=top><img src=https://fms5.amazoncar.co.kr/mailing/total/images/cfms_bar_1.gif width=683 height=21></td>
		                	</tr>
		                    <tr>
		                        <td>
		                        	<table width=683 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/total/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/total/images/con_up.gif width=683 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                                            <td width=643>
                                                <table width=643 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=20 align=left>&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style2>아마존카<span class=style13><b>고객FMS 접속</b></span> (<a href=https://fms.amazoncar.co.kr/service/index.jsp target="_blank">https://fms.amazoncar.co.kr</a>)</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=15></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 align=center><img src=https://fms5.amazoncar.co.kr/mailing/total/images/cfms_img1.gif></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=15></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/total/images/con_dw.gif width=683 height=7></td>
                                        </tr>
                                    </table>
                            	</td>
		               		</tr>
		                    <tr>
		                        <td height=25></td>
		            		</tr>
		                    <tr>
		                        <td height=24 valign=top><img src=https://fms5.amazoncar.co.kr/mailing/total/images/cfms_bar_2.gif width=683 height=21></td>
		         			</tr>
		                    <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/total/images/cfms_img2.gif usemap=#Map border=0></td>
                            </tr>
                           	<map name="Map">
					            <area shape="rect" coords="145,152,216,174" href="javascript:ViewLayer();">
					            <area shape="rect" coords="357,152,430,174" href="javascript:ViewLayer2();">
					            <area shape="rect" coords="575,152,644,174" href="javascript:ViewLayer3();">
					            <area shape="rect" coords="149,321,216,343" href="javascript:ViewLayer4();">
					            <area shape="rect" coords="360,321,430,343" href="javascript:ViewLayer5();">
					            <area shape="rect" coords="576,321,644,343" href="javascript:ViewLayer6();">
					            <area shape="rect" coords="146,489,216,511" href="javascript:ViewLayer7();">
					            <area shape="rect" coords="360,489,430,511" href="javascript:ViewLayer8();">
					        </map>
	                	</table>
	              	</td>
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

<div id="layer1" style="position:absolute; left:500px; top:1695px; width:261px; height:70px; z-index:1; display:none;">
<table width="209" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><a href="javascript:hidden();"><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/cfms_content1.png border=0></a></td>
    </tr>
</table>  
</div>

<div id="layer2" style="position:absolute; left:400px; top:1817px; width:261px; height:70px; z-index:1; display:none;">
<table width="209" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><a href="javascript:hidden2();"><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/cfms_content2.png border=0></a></td>
    </tr>
</table>  
</div>

<div id="layer3" style="position:absolute; left:383px; top:1693px; width:261px; height:70px; z-index:1; display:none;">
<table width="209" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><a href="javascript:hidden3();"><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/cfms_content3.png border=0></a></td>
    </tr>
</table>  
</div>

<div id="layer4" style="position:absolute; left:500px; top:1815px; width:261px; height:70px; z-index:1; display:none;">
<table width="209" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><a href="javascript:hidden4();"><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/cfms_content4.png border=0></a></td>
    </tr>
</table>  
</div>

<div id="layer5" style="position:absolute; left:400px; top:1991px; width:261px; height:70px; z-index:1; display:none;">
<table width="209" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><a href="javascript:hidden5();"><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/cfms_content5.png border=0></a></td>
    </tr>
</table>  
</div>

<div id="layer6" style="position:absolute; left:383px; top:1855px; width:261px; height:70px; z-index:1; display:none;">
<table width="209" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><a href="javascript:hidden6();"><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/cfms_content6.png border=0></a></td>
    </tr>
</table>  
</div>

<div id="layer7" style="position:absolute; left:500px; top:2041px; width:261px; height:70px; z-index:1; display:none;">
<table width="209" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><a href="javascript:hidden7();"><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/cfms_content7.png border=0></a></td>
    </tr>
</table>  
</div>

<div id="layer8" style="position:absolute; left:400px; top:1689Px; width:261px; height:70px; z-index:1; display:none;">
<table width="209" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><a href="javascript:hidden8();"><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/cfms_content8.png border=0></a></td>
    </tr>
</table>  
</div>


</body>
</html>