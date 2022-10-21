<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, java.net.*, acar.util.*, acar.common.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>

<%
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String content_st = request.getParameter("content_st")==null?"":request.getParameter("content_st");
	String pack_id 	= request.getParameter("pack_id")==null?"":request.getParameter("pack_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String est_nm 	= request.getParameter("est_nm")==null?"":request.getParameter("est_nm");
	String rent_dt  = "";
	String memo     = "";
	String est_talbe= "estimate";
	String sh_all_param1 = "";
	String sh_all_param2 = "";
	String sh_all_param3 = "";
	String sh_all_param4 = "";
	String sh_all_cust_info = "";
	
	String br_from		= request.getParameter("br_from")==null?"":request.getParameter("br_from");
	String br_to		= request.getParameter("br_to")==null?"":request.getParameter("br_to");
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//테이블 가져오기
	est_talbe = e_db.getEstiPackEstTableNm(pack_id);
	
	Vector vt = e_db.getEstiPackList(pack_id, est_talbe);
	int vt_size = vt.size();
	
	for(int i=0; i<vt_size; i++){
    	Hashtable ht = (Hashtable)vt.elementAt(i);
    	if(from_page.equals("estimate_comp_fms_sh.jsp")){
	    	if(!String.valueOf(ht.get("MEMO")).equals("")){
				String[] arr = String.valueOf(ht.get("MEMO")).split("%/%");
				if(i==0){	memo = arr[0];
							sh_all_param1 = arr[1];
							rent_dt = String.valueOf(ht.get("RENT_DT"));
							user_id = String.valueOf(ht.get("REG_ID"));		}
				if(i==1){	sh_all_param2 = arr[1];		}
				if(i==2){	sh_all_param3 = arr[1];		}
				if(i==3){	sh_all_param4 = arr[1];		}
				if(String.valueOf(ht.get("SEQ")).equals("1")){		sh_all_cust_info = URLEncoder.encode(arr[2],"EUC-KR");		}	
			}
    	}else{
			if(i==0){
				rent_dt = String.valueOf(ht.get("RENT_DT"));
				user_id = String.valueOf(ht.get("REG_ID"));
				memo    = String.valueOf(ht.get("MEMO"));
			}
    	}
		if(est_nm.equals("")) 	est_nm 	= String.valueOf(ht.get("EST_NM"));
	}
	
	
	//사용자 정보 조회
	if(!user_id.equals("") && !user_id.equals("system") && !user_id.equals("SYSTEM")){
		user_bean 	= umd.getUsersBean(user_id);
	}
	
	if(user_id.equals("") || user_id.equals("system") || user_id.equals("SYSTEM")){
		user_id = "";
		est_nm = "고객";
	}
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>아마존카 장기대여 견적서</title>
<style type="text/css">
<!--
.style1 {color: #373737}
.style2 {color: #63676a}
.style3 {color: #ff8004}
.style4 {color: #c09b33; font-weight: bold;}
.style5 {color: #c39235}
.style6 {color: #8b8063;}
.style7 {color: #77786b}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:8pt;}
.style14 {color: #af2f98; font-size:8pt;}
-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>

<script language="JavaScript">
<!--
//New 로그인
	function getLogin2(member_id, pwd){	
		var w = 450;
		var h = 250;
		var winl = (screen.width - w) / 2;
		var wint = (screen.height - h) / 2;
		var SUBWIN="https://fms.amazoncar.co.kr/service/index.jsp?name="+member_id+"&passwd="+pwd;	
//		window.open(SUBWIN, "InfoUp", "left="+winl+", top="+wint+", width="+w+", height="+h+", scrollbars=yes");
		window.open(SUBWIN, "InfoUp1", "left=5, top=5, width=1240, height=760, scrollbars=yes, status=yes, menubar=yes, toolbar=yes, resizable=yes");		
		
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
//-->
</script>
</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target="_blank" onFocus="this.blur();"><img src="https://fms5.amazoncar.co.kr/mailing/images/logo.gif" width=332 height=52 border=0></a></td>
            		<!-- 고객 FMS로그인 버튼 -->
                    <td width=114 valign=baseline>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top_est.gif></td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=676 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine1.gif>
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=435 height=35 align="left"><span style="font-family:nanumgothic;font-size:13px;"><b><%=est_nm%> </b>님</span></td>
                    <td width=221 align="left"><span style="font-family:nanumgothic;font-size:12px;"><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_ddj.gif align=absmiddle>&nbsp;&nbsp;<%if(user_bean.getUser_nm().equals("권웅철")){%>유재석<%}else{%><%=user_bean.getUser_nm()%><%}%>&nbsp;&nbsp;<%=user_bean.getUser_m_tel()%></span></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=676 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine2.gif>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=636>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=24 align="left"><span style="font-family:nanumgothic;font-size:13px;"><b><%=AddUtil.getDate3(rent_dt)%></b> 고객님께서 요청하신 견적서입니다.</span></td>
                            </tr>
                            <tr>
                                <td height=10></td>
                            </tr>
                            <tr>
                                <td height=18 align="left"><span style="font-family:nanumgothic;font-size:13px;line-height:20px;">견적내용 살펴보시고, 견적서보기에서 <span style="color:red;">견적클릭!</span>을 누르시면 해당 견적서가 보여집니다.<br>
                         		견적클릭 후 <span style="color:red;">차종(차량모델명)</span>을 누르시면 차량 상세사양정보가 보여집니다.<br>
                            	아마존카를 이용해 주셔서 진심으로 감사드리며, 궁금하신 사항이 있으시면 담당자에게 전화주시기 바랍니다.</span></td>
                            </tr>
                        </table>
                    </td>
                    <td width=20>&nbsp;</td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine_dw.gif></td>
                </tr>
            </table>
        </td>
    </tr>

    <tr>
        <td height=30 align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=656 border=0 cellspacing=0 cellpadding=0>
                
                <tr>
                    <td height=20></td>
                </tr>
                <tr>
                    <td align="left">&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_est.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                	<td align=center>
                		<table width=648 border=0 cellspacing=0 cellpadding=0>
                			<tr>
                        		<td height=2 bgcolor=656e7f colspan=2></td>
                        	</tr>
                        </table>
      				</td>
                </tr>
                <tr>
                    <td align=center>
                        <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=d6d6d6>
                            <tr>
                                <td bgcolor=f2f2f2 height=30 width=450 align=center><span style="font-family:nanumgothic;font-size:12px;">견적내용</span></td>
                                <td bgcolor=f2f2f2 align=center><span style="font-family:nanumgothic;font-size:12px;">견적서보기</span></td>
                            </tr>
				             <%  String esti_content_a = "";
								 int ss_content = 0;
								 String param1 ="";
								 String param2 ="";
								 String param3 ="";
								 String param4 ="";
								 for(int i=0; i<vt_size; i++){
								
									Hashtable ht = (Hashtable)vt.elementAt(i);
											
									String esti_content_b = String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME"))+" "+String.valueOf(ht.get("GOOD_NM"))+" "+String.valueOf(ht.get("A_B"))+"개월";
									
									if(content_st.equals("hp") || content_st.equals("hp_fms") || content_st.equals("hp_renew") || content_st.equals("hp_renew_all") || content_st.equals("hp_comp_fms")){
										esti_content_b = String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME"))+" "+String.valueOf(ht.get("GOOD_NM"))+" "+String.valueOf(ht.get("A_B"))+"개월";
									}else if(content_st.equals("sh") || content_st.equals("sh_fms") || content_st.equals("sh_fms_ym")){
										esti_content_b = String.valueOf(ht.get("CAR_NO"))+" "+String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME"))+" "+String.valueOf(ht.get("GOOD_NM"))+" "+String.valueOf(ht.get("A_B"))+"개월";
									}else if(content_st.equals("sh_rm") || content_st.equals("sh_rm_new") || content_st.equals("sh_rm_fms") || content_st.equals("sh_rm_fms_new")){
										esti_content_b = String.valueOf(ht.get("CAR_NO"))+" "+String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME"))+" 월렌트 "+String.valueOf(ht.get("A_B"))+"개월";
									}else{
										if(String.valueOf(ht.get("CAR_GU")).equals("0")){//재리스
											if(String.valueOf(ht.get("EST_FROM")).equals("rm_car") || String.valueOf(ht.get("MGR_SSN")).equals("rm1")){
												esti_content_b = String.valueOf(ht.get("CAR_NO"))+" "+String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME"))+" 월렌트 "+String.valueOf(ht.get("A_B"))+"개월";
											}else{
												esti_content_b = String.valueOf(ht.get("CAR_NO"))+" "+String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME"))+" 재리스 "+String.valueOf(ht.get("GOOD_NM"))+" "+String.valueOf(ht.get("A_B"))+"개월";
											}
										}
									}
		
									if(esti_content_a.equals(esti_content_b)){
										ss_content++;
									}else{
										ss_content = 0;
									}	
									esti_content_a = esti_content_b;
									
									if(from_page.equals("estimate_comp_fms_sh.jsp")){
										
										Hashtable ht2 = e_db.getEstimateSh(String.valueOf(ht.get("EST_ID")));
										if(i==0){	param1 = String.valueOf(ht2.get("A_A"))+"//"+String.valueOf(ht2.get("MAX_USE_MON"))+"//"+String.valueOf(ht2.get("RBMAX"))+"//"+String.valueOf(ht2.get("RBMAX_ID"));	}
										if(i==1){	param2 = String.valueOf(ht2.get("A_A"))+"//"+String.valueOf(ht2.get("MAX_USE_MON"))+"//"+String.valueOf(ht2.get("RBMAX"))+"//"+String.valueOf(ht2.get("RBMAX_ID"));	}
										if(i==2){	param3 = String.valueOf(ht2.get("A_A"))+"//"+String.valueOf(ht2.get("MAX_USE_MON"))+"//"+String.valueOf(ht2.get("RBMAX"))+"//"+String.valueOf(ht2.get("RBMAX_ID"));	}
										if(i==3){	param4 = String.valueOf(ht2.get("A_A"))+"//"+String.valueOf(ht2.get("MAX_USE_MON"))+"//"+String.valueOf(ht2.get("RBMAX"))+"//"+String.valueOf(ht2.get("RBMAX_ID"));	}
										
										if(String.valueOf(ht.get("SEQ")).equals("1")){
							%>
							<tr>
								<td bgcolor=ffffff height=30 align="left">&nbsp;<span style="font-family:nanumgothic;font-size:12px;"><%=esti_content_b%> 견적 <%if(ss_content>0){%>(<%=ss_content+1%>)<%}%></span></td>
								<td bgcolor=ffffff align=center>&nbsp;<span style="font-family:nanumgothic;font-size:12px;">
									<a href="http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate_comp_fms_sh.jsp?from_page=estimate_comp_fms_sh.jsp&param1=<%=sh_all_param1%>&param2=<%=sh_all_param2%>&param3=<%=sh_all_param3%>&param4=<%=sh_all_param4%>&br_from=<%=br_from%>&br_to=<%=br_to%>&cust_info=<%=sh_all_cust_info%>" target="_blank" title='견적서보기'>견적클릭!</a>
								</span></td>
							</tr>
							<%			}else{	continue;	}
									}else{
							%>
                            <tr>
                                <td bgcolor=ffffff height=30 align="left">&nbsp;<span style="font-family:nanumgothic;font-size:12px;"><%=esti_content_b%> 견적 <%if(ss_content>0){%>(<%=ss_content+1%>)<%}%></span></td>
                                <td bgcolor=ffffff align=center>&nbsp;<span style="font-family:nanumgothic;font-size:12px;">
								  <%if(content_st.equals("hp")){%>
		            				<a href="http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate.jsp?&acar_id=&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
								  <%}else if(content_st.equals("hp_fms")){%>
		            				<a href="http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_fms.jsp?from_page=/acar/estimate_mng/esti_mng_u.jsp&acar_id=<%=user_id%>&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
								  <%}else if(content_st.equals("hp_renew")){%>
	        						<a href="http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_renew.jsp?from_page=/acar/estimate_mng/esti_mng_u.jsp&acar_id=<%=user_id%>&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
								  <%}else if(content_st.equals("hp_renew_all")){%>
	        						<a href="http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_renew_all.jsp?from_page=/acar/estimate_mng/esti_mng_u.jsp&acar_id=<%=user_id%>&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
								  <%}else if(content_st.equals("hp_comp_fms")){%>
	        						<a href="http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_comp_fms.jsp?from_page=/acar/estimate_mng/esti_mng_u.jsp&acar_id=<%=user_id%>&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
								  <%}else if(content_st.equals("sh")){%>
	        						<a href="http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate.jsp?from_page=&acar_id=&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>	
						  		  <%}else if(content_st.equals("sh_fms")){%>
	        						<a href="http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate_fms.jsp?from_page=/acar/estimate_mng/esti_mng_u.jsp&acar_id=<%=user_id%>&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
								  <%}else if(content_st.equals("sh_fms_ym")){%>
        							<a href="http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate_fms_ym.jsp?from_page=/acar/estimate_mng/esti_mng_u.jsp&acar_id=<%=user_id%>&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
								  <%}else if(content_st.equals("sh_rm") || content_st.equals("sh_rm_new") || content_st.equals("sh_rm_fms") || content_st.equals("sh_rm_fms_new")){%>
    								<%if(user_id.equals("") || user_id.equals("system") || user_id.equals("SYSTEM")){%>
		        						<a href="http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate_rm_new.jsp?from_page=&acar_id=SYSTEM&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
    								<%}else{%>
		        						<a href="http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate_rm_new.jsp?from_page=/acar/estimate_mng/esti_mng_u.jsp&acar_id=<%=user_id%>&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
    								<%}%>
    							  <%}else if(content_st.equals("hp_eh_all")){%>
	        						<%-- <a href="http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_eh_all.jsp?from_page=/acar/estimate_mng/esti_mng_u.jsp&acar_id=<%=user_id%>&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a> --%>	
	        						<a href="http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_eh_all.jsp?from_page=<%=from_page%>&acar_id=<%=user_id%>&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
                               	  <%}else{%>
										<%if(String.valueOf(ht.get("CAR_GU")).equals("0")){//재리스%>
	    									<%if(String.valueOf(ht.get("EST_FROM")).equals("rm_car") || String.valueOf(ht.get("MGR_SSN")).equals("rm1")){//월렌트%>
	    										<%if(user_id.equals("") || user_id.equals("system") || user_id.equals("SYSTEM")){%>
	        										<a href="http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate_rm_new.jsp?from_page=&acar_id=SYSTEM&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
	    										<%}else{%>
	        										<a href="http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate_rm_new.jsp?from_page=/acar/estimate_mng/esti_mng_u.jsp&acar_id=<%=user_id%>&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
	    										<%}%>
	    									<%}else{//재리스%>
	    										<%if(user_id.equals("") || user_id.equals("system") || user_id.equals("SYSTEM")){%>
	        									<a href="http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate.jsp?from_page=&acar_id=&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
	    										<%}else{%>
	        									<a href="http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate_fms.jsp?from_page=/acar/estimate_mng/esti_mng_u.jsp&acar_id=<%=user_id%>&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
	    										<%}%>
	    									<%}%>
										<%}else{//신차%>
	    									<%if(String.valueOf(ht.get("PACK_ST")).equals("2")){%>
	        									<a href="http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_renew.jsp?from_page=/acar/estimate_mng/esti_mng_u.jsp&acar_id=<%=user_id%>&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
	    									<%}else if(String.valueOf(ht.get("PACK_ST")).equals("3")){%>
	        									<a href="http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_renew_all.jsp?from_page=/acar/estimate_mng/esti_mng_u.jsp&acar_id=<%=user_id%>&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
	    									<%}else{%>
	        									<%if(String.valueOf(ht.get("PRINT_TYPE")).equals("2")||String.valueOf(ht.get("PRINT_TYPE")).equals("3")){%>
	            									<a href="http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_renew.jsp?from_page=/acar/estimate_mng/esti_mng_u.jsp&acar_id=<%=user_id%>&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
	        									<%}else if(String.valueOf(ht.get("PRINT_TYPE")).equals("4")){%>
	            									<a href="http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_renew_all.jsp?from_page=/acar/estimate_mng/esti_mng_u.jsp&acar_id=<%=user_id%>&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
            									<%}else if(String.valueOf(ht.get("PRINT_TYPE")).equals("6")){%>
	            									<a href="http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_eh_all.jsp?from_page=/acar/estimate_mng/esti_mng_u.jsp&acar_id=<%=user_id%>&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
	        									<%}else{%>
	        										<%if(user_id.equals("") || user_id.equals("system") || user_id.equals("SYSTEM")){%>
	            										<a href="http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate.jsp?&acar_id=&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
	        										<%}else{%>
	            										<a href="http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_fms.jsp?from_page=/acar/estimate_mng/esti_mng_u.jsp&acar_id=<%=user_id%>&est_id=<%=ht.get("EST_ID")%>&content_st=<%=content_st%>&opt_chk=<%=ht.get("OPT_CHK")%>&mail_yn=N" target="_blank" title='견적서보기'>견적클릭!</a>
	        										<%}%>
	        									<%}%>
	    									<%}%>
										<%}%>
									<%}%>
				                  </span>
				                </td>
                            </tr>
				              <%	}
								}%>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=20></td>
                </tr>
                <tr>
                    <td align="left">&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_memo.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                
                <tr>
                    <td align=center>
                        <table width=648 border=0 cellspacing=0 cellpadding=0>
                        	<tr>
                        		<td height=2 bgcolor=656e7f></td>
                        	</tr>
                            <tr>
                            	<td>
                            		<table width=648 border=0 cellspacing=0 cellpadding=20 bgcolor=f2f2f2>
                            			<tr>
                                			<td><span style="font-family:nanumgothic;font-size:12px;"><%=memo%></span></td>
                                		</tr>
                                	</table>
                                </td>
                            </tr>
                            <tr>
                            	<td height=1 bgcolor=d6d6d6></td>
                            </tr>
                        </table>
                    </td>
                </tr>
				<tr>
					<td height=60></td>
				</tr>                
            </table>
        </td>
    </tr>
    <tr>
        <td align=center backgrounds=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 backgrounds=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=35>&nbsp;</td>
                    <td width=85><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.gif></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
                <map name=Map1>
                    <area shape=rect coords=283,53,403,67 href=mailto:tax@amazoncar.co.kr>
                </map>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_bottom.gif width=700 height=21></td>
    </tr>
</table>
</body>
</html>