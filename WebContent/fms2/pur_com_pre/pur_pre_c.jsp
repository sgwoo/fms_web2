<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.car_office.*, acar.user_mng.*, acar.cont.*,acar.client.*, acar.car_mst.*"%>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String opt1 		= request.getParameter("opt1")		==null?"":request.getParameter("opt1");
	String opt2 		= request.getParameter("opt2")		==null?"":request.getParameter("opt2");
	String opt3 		= request.getParameter("opt3")		==null?"":request.getParameter("opt3");
	String opt4 		= request.getParameter("opt4")		==null?"":request.getParameter("opt4");
	String opt5 		= request.getParameter("opt5")		==null?"":request.getParameter("opt5");
	String opt6 		= request.getParameter("opt6")		==null?"":request.getParameter("opt6");
	String opt7 		= request.getParameter("opt7")		==null?"":request.getParameter("opt7");
	String e_opt1 		= request.getParameter("e_opt1")	==null?"":request.getParameter("e_opt1");
	String e_opt2 		= request.getParameter("e_opt2")	==null?"":request.getParameter("e_opt2");
	String e_opt3 		= request.getParameter("e_opt3")	==null?"":request.getParameter("e_opt3");
	String e_opt4 		= request.getParameter("e_opt4")	==null?"":request.getParameter("e_opt4");
	String e_opt5 		= request.getParameter("e_opt5")	==null?"":request.getParameter("e_opt5");
	String e_opt6 		= request.getParameter("e_opt6")	==null?"":request.getParameter("e_opt6");
	String e_opt7 		= request.getParameter("e_opt7")	==null?"":request.getParameter("e_opt7");
	String ready_car	= request.getParameter("ready_car")	==null?"":request.getParameter("ready_car");
	String eco_yn		= request.getParameter("eco_yn")	==null?"":request.getParameter("eco_yn");

	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");

	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");

	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	if(seq.equals("")){
		out.println("seq 값이 없습니다. 사용할 수 없습니다. "); return;
	}

	CarOffPreBean bean = cop_db.getCarOffPreSeq(seq);
	
	//예약자리스트
	Vector vt = cop_db.getCarOffPreSeqResList(seq);
	int vt_size = vt.size();
	
	String vlaus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
			"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort="+sort+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+
			"&st_dt="+st_dt+"&end_dt="+end_dt+"&from_page="+from_page+
			"&opt1="+opt1+"&opt2="+opt2+"&opt3="+opt3+"&opt4="+opt4+"&opt5="+opt5+"&opt6="+opt6+"&opt7="+opt7+
			"&e_opt1="+e_opt1+"&e_opt2="+e_opt2+"&e_opt3="+e_opt3+"&e_opt4="+e_opt4+"&e_opt5="+e_opt5+"&e_opt6="+e_opt6+"&e_opt7="+e_opt7+
			"&ready_car="+ready_car+"&eco_yn="+eco_yn+
		   	"&seq="+seq+"";
	
		
	user_bean 	= umd.getUsersBean(user_id);
	
	String res_yn = "N";	
	int res_cnt = 0;
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	String dept_id = login.getDept_id(user_id);
	
	eco_yn = "미입력";
	
	if (bean.getEco_yn().equals("0")) {
		eco_yn = "가솔린엔진";
	} else if (bean.getEco_yn().equals("1")) {
		eco_yn = "디젤엔진";
	} else if (bean.getEco_yn().equals("2")) {
		eco_yn = "LPG엔진";
	} else if (bean.getEco_yn().equals("3")) {
		eco_yn = "하이브리드";
	} else if (bean.getEco_yn().equals("4")) {
		eco_yn = "플러그인 하이브리드";
	} else if (bean.getEco_yn().equals("5")) {
		eco_yn = "전기차";
	} else if (bean.getEco_yn().equals("6")) {
		eco_yn = "수소차";
	} else {
		eco_yn = "미입력";
	}
	
	//자체출고관리 여부
	CarPurDocListBean cpd_bean = cod.getCarPurCom(bean.getCom_con_no());
	
	String a_rent_l_cd = "";
	String a_firm_nm = "";
	String a_dlv_ext = "";
	String a_udt_st = "";
	
	String b_rent_l_cd = "";
	String b_firm_nm = "";
	String b_dlv_ext = "";
	String b_udt_st = "";

%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//리스트
	function list(){
		var fm = document.form1;
		fm.action = 'pur_pre_frame.jsp';
		fm.target = 'd_content';
		fm.submit();
	}	

	//수정
	function update(st, seq){
		var height = 250;
		
		if(st == 'com_con_no') 		height = 250;
		else if(st == 'car') 		height = 600;
		else if(st == 'res_u') 		height = 300;	
		else if(st == 'res_i') 		height = 350;	
		else if(st == 'cont') 		height = 250;		
				
		window.open("pur_pre_u.jsp<%=vlaus%>&cng_item="+st+"&r_seq="+seq, "CHANGE_ITEM", "left=50, top=50, width=1050, height="+height+", scrollbars=yes, status=yes");
	}	
	
	//바로처리
	function dir_update(st, seq){
	
		var fm = document.form1;
		fm.cng_item.value = st;
		fm.r_seq.value = seq;
		fm.action = 'pur_pre_u_a.jsp';
		fm.target = 'i_no';
		fm.submit();
	}
	
	//즉시출고 
	function pre_out_yn(st, mode, rent_l_cd){
		
		if(mode=='Y' && rent_l_cd!=''){		alert("연동된 계약이 있어 즉시출고 처리할수없습니다.");	return;		}
		var text = '';
		if(mode=='Y'){	text='즉시출고';	}
		else{			text='즉시출고 취소';	}
		
		if(confirm(text+" 처리 하시겠습니까?")){
			var fm = document.form1;
			fm.cng_item.value = st;
			fm.pre_out_yn.value = mode;
			fm.action = 'pur_pre_u_a.jsp';
			fm.target = 'i_no';
			fm.submit();	
		}
	}
	
	function restore_pre_cont(){
		if(confirm("취소 -> 진행중 으로 복구 하시겠습니까?")){
			var fm = document.form1;
			fm.cng_item.value = "cls_restore";
			fm.action = 'pur_pre_u_a.jsp';
			fm.target = 'i_no';
			fm.submit();	
		}
	}
	
	function reEstimate() {
		var fm = document.form2;
		var dept_id = fm.dept_id.value;
		
		if (dept_id == "1000") {
			fm.action = "/agent/estimate_mng/esti_mng_atype_i.jsp";
		} else {
			fm.action = "/acar/estimate_mng/esti_mng_atype_i.jsp";
		}
		
		fm.target = 'd_content';
		fm.submit();
	}
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form2" method="POST">
	<input type="hidden" name="auth_rw" 	value='<%=auth_rw%>'>
	<input type="hidden" name="user_id" 	value='<%=user_id%>'>
	<input type="hidden" name="br_id" 		value='<%=br_id%>'>
	<input type="hidden" name="dept_id" 	value='<%=dept_id%>'>
	<input type="hidden" name="pur_seq" 			value='<%=seq%>'>
	<input type="hidden" name="pur_car_nm" value='<%=bean.getCar_nm()%>'>
	<input type="hidden" name="pur_car_opt" value='<%=bean.getOpt()%>'>
	<input type="hidden" name="pur_car_col" value='<%=bean.getColo()%>'>
	<input type="hidden" name="pur_car_in_col" value='<%=bean.getIn_col()%>'>
	<input type="hidden" name="pur_car_garnish_col" value='<%=bean.getGarnish_col()%>'>
	
	<input type="hidden" name="pur_eco_yn" value='<%=eco_yn%>'>
   	<input type="hidden" name="pur_car_amt" value='<%=AddUtil.parseDecimal(bean.getCar_amt())%>'>
   	<input type="hidden" name="pur_con_amt" value='<%=AddUtil.parseDecimal(bean.getCon_amt())%>'>
   	<input type="hidden" name="pur_dlv_est_dt" value='<%=AddUtil.ChangeDate2(bean.getDlv_est_dt())%>'>
   	<input type="hidden" name="pur_con_pay_dt" value='<%=AddUtil.ChangeDate2(bean.getCon_pay_dt())%>'>
   	<input type="hidden" name="pur_etc" value='<%=bean.getEtc()%>'>
	
	<input type="hidden" name="pur_from_page" value="pur_pre_c.jsp">
</form>
<form action="" name="form1" method="POST">
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>
	<input type='hidden' name='br_id' 		value='<%=br_id%>'>
	<input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
	<input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
	<input type='hidden' name='sort'			value='<%=sort%>'>
	<input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
	<input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
	<input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
	<input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
	<input type='hidden' name='gubun5' 	value='<%=gubun5%>'> 
	<input type='hidden' name='st_dt' 		value='<%=st_dt%>'>  
	<input type='hidden' name='end_dt' 		value='<%=end_dt%>'>  
	<input type='hidden' name="from_page" value="<%=from_page%>">
	<input type='hidden' name="seq" 		value="<%=seq%>">
	<input type='hidden' name="mode" 		value="<%=mode%>">  
	<input type='hidden' name="cng_item" 	value="">  
	<input type='hidden' name="r_seq" 		value=""> 
	<input type='hidden' name='opt1' 		value='<%=opt1%>'>
	<input type='hidden' name='opt2' 		value='<%=opt2%>'>
	<input type='hidden' name='opt3' 		value='<%=opt3%>'>
	<input type='hidden' name='opt4' 		value='<%=opt4%>'>
	<input type='hidden' name='opt5' 		value='<%=opt5%>'>
	<input type='hidden' name='opt6' 		value='<%=opt6%>'>
    <input type='hidden' name='opt7' 		value='<%=opt7%>'>
	<input type='hidden' name='e_opt1' 		value='<%=e_opt1%>'>
	<input type='hidden' name='e_opt2' 		value='<%=e_opt2%>'>
	<input type='hidden' name='e_opt3' 		value='<%=e_opt3%>'>
	<input type='hidden' name='e_opt4' 		value='<%=e_opt4%>'>
	<input type='hidden' name='e_opt5' 		value='<%=e_opt5%>'>
	<input type='hidden' name='e_opt6' 	value='<%=e_opt6%>'>
    <input type='hidden' name='e_opt7' 	value='<%=e_opt7%>'>
	<input type='hidden' name='ready_car' value='<%=ready_car%>'>
    <input type='hidden' name='eco_yn' value='<%=eco_yn%>'>
	<input type='hidden' name='pre_out_yn'value=''>  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>계출관리 > <span class=style5>사전계약보기</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <%if(!mode.equals("view")){%>
    <tr>
        <td align="right"><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a></td></td>
    <tr> 	
    <%}%>
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=13% class=title>출고영업소</td>
                    <td width=17%>&nbsp;
                    	<%=bean.getCar_off_nm()%>
                    </td>
                    <td width=10% class=title>계출번호</td>
                    <td width=20%>&nbsp;
                    	<%=bean.getCom_con_no()%>
                  		<%if (!mode.equals("view")) {%> 
							<%if (bean.getUse_yn().equals("Y")) {%>
								<%if (nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("총무팀남",ck_acar_id) || nm_db.getWorkAuthUser("영업팀내근직",ck_acar_id)) {%>
                    				&nbsp;<a href='javascript:update("com_con_no", "")'><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
                    			<%}%>
                    		<%}%>
                    	<%}%>
                    	
                    </td>
                    <td width=10% class=title>요청일시</td>
                    <td width=30%>&nbsp;
                    	<%=bean.getReq_dt()%>
                    	<%if (!mode.equals("view")) {%> 
							<%if (bean.getUse_yn().equals("Y")) {%>
								<%if (nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("총무팀남",ck_acar_id) || nm_db.getWorkAuthUser("영업팀내근직",ck_acar_id)) {%>
                    				&nbsp;<a href='javascript:update("req", "")'><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
                    			<%}%>
                    		<%}%>
                    	<%}%>
                    </td>
                </tr>
                <%if(bean.getUse_yn().equals("N")){%>
                <tr> 
                    <td width=13% class=title>계약해지일</td>
                    <td colspan='5'>&nbsp;
                    	<%=AddUtil.ChangeDate2(bean.getCls_dt())%>
                    </td>
                </tr>                
                <%}%>
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>
    <tr>
		<td>
      		<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정보</span>          		
      		<%if(ck_acar_id.equals("000029")){ %>
      		&nbsp;&nbsp;(등록일시 : <%=bean.getReg_dt()%>)
      		<%} %>
      	</td>
    </tr>    
      		<%if(!acar_de.equals("1000")){ %>

    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                 <tr> 
                    <td width=13% class=title>자체영업여부</td>
                    <td colspan="3">&nbsp;
                    	<input type="checkbox" name="bus_self_yn" value="Y" <%if (bean.getBus_self_yn().equals("Y")){%>checked<%}%>> 자체영업
                    </td>
                </tr>
                <%if (!bean.getQ_reg_dt().equals("")){%>
                <tr> 
                    <td width=13% class=title>Q코드</td>
                    <td colspan="3">&nbsp;
                    	<input type="checkbox" name="q_reg_dt" value="Y" <%if (!bean.getQ_reg_dt().equals("")){%>checked<%}%>> 4시간 동안은 자체영업 고객만 예약 가능 <%if (!bean.getQ_reg_dt().equals("")){%>(<%=bean.getQ_reg_dt()%>부터)<%}%> 
                    </td>
                </tr>
                <%}%>
                <tr> 
                    <td width=13% class=title>에이전트노출여부</td>
                    <td colspan="3">&nbsp;
                    	<input type="checkbox" name="agent_view_yn" value="Y" <%if (bean.getAgent_view_yn().equals("Y")){%>checked<%}%>> 에이전트에 차량 보이기
                    </td>
                </tr>
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>    
      		<%} %>

    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>                            
                <tr> 
                    <td width=13% class=title>차명</td>
                    <td colspan="3">&nbsp;
                    	<%=bean.getCar_nm()%>
<%--                     	<%if (nm_db.getWorkAuthUser("전산팀", ck_acar_id) || nm_db.getWorkAuthUser("총무팀남", ck_acar_id) || nm_db.getWorkAuthUser("영업팀내근직", ck_acar_id) || dept_id.equals("1000")) {%> --%>
	                    	&nbsp;&nbsp;&nbsp;&nbsp;
	      					<a href="javascript:reEstimate();" class="button" onMouseOver="window.status=''; return true" onfocus="this.blur()" style="text-decoration: none;">신차견적내기</a>
<%--                			<%}%> --%>
                    </td>
                </tr>
                <tr> 
                    <td width=13% class=title>선택품목</td>
                    <td colspan="3">&nbsp;
                    	<%=bean.getOpt()%>
                    </td>
                </tr>
                <tr> 
                    <td width=13% class=title>색상</td>
                    <td colspan="3">&nbsp;
                    	외장 : <%=bean.getColo()%>&nbsp;내장 : <%=bean.getIn_col()%>&nbsp;가니쉬 : <%=bean.getGarnish_col()%>
                    </td>
                </tr>
                <tr> 
                    <td width=13% class=title>엔진</td>
                    <td colspan="3">&nbsp;
                   		<%=eco_yn%>
					</td>
                </tr>
                <tr>
                  	<td class=title>소비자가</td>
                  	<td width="37%">&nbsp;
                  		<%=AddUtil.parseDecimal(bean.getCar_amt())%>원
                  	</td>
                  	<td width=10% class=title>출고예정일</td>
                  	<td width="40%">&nbsp;
                  		<%=AddUtil.ChangeDate2(bean.getDlv_est_dt())%>
                  	</td>
                </tr>	
                <tr>
                  	<td class=title>계약금</td>
                  	<td colspan='3'>&nbsp;
                  		<%=AddUtil.parseDecimal(bean.getCon_amt())%>원
                  		&nbsp;
                     지급수단 :
                     <select name="trf_st0"  disabled>
                        <option value="">==선택==</option>
        				<option value="3" <%if(bean.getTrf_st0().equals("3")) out.println("selected");%>>카드</option>
        				<option value="1" <%if(bean.getTrf_st0().equals("1")) out.println("selected");%>>현금</option>
        			  </select> 
                     &nbsp;
                    금융사 :
					<%=bean.getCon_bank()%>
				  	&nbsp;
				  	계좌종류 :
				  	<select name="acc_st0"  disabled>
                        <option value="">==선택==</option>
        				<option value="1" <%if(bean.getAcc_st0().equals("1")) out.println("selected");%>>영구계좌</option>
        				<option value="2" <%if(bean.getAcc_st0().equals("2")) out.println("selected");%>>가상계좌</option>
        			  </select>
				  	&nbsp;
					계좌번호 : 
        			<input type='text' name='con_acc_no' value='<%=bean.getCon_acc_no()%>' size='20' class='whitetext'>
					&nbsp;
					예금주 : 
        			<input type='text' name='con_acc_nm' value='<%=bean.getCon_acc_nm()%>' size='15' class='whitetext'>
        			<br>
        			&nbsp;
        			지급요청일 :
        			<input type='text' name='con_est_dt' value='<%= AddUtil.ChangeDate2(bean.getCon_est_dt())%>' class='whitetext' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
                  	</td>
                </tr>
                <tr>
                  	<td class=title>계약금지급일</td>
                  	<td colspan='3'>&nbsp;
                  		<%=AddUtil.ChangeDate2(bean.getCon_pay_dt())%>
                  	</td>
                </tr>
                <tr> 
                    <td width=13% class=title>비고</td>
                    <td colspan="3">&nbsp;
                    	<%=bean.getEtc()%>
                    </td>
                </tr>      
            </table>
        </td>
    </tr> 
	  <%if(bean.getUse_yn().equals("Y")){%>
    <tr>
	      <td align='right' style="padding: 5px;">	 
        	<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("총무팀남",ck_acar_id) || nm_db.getWorkAuthUser("영업팀내근직",ck_acar_id)){%>     
        		<a href="javascript:update('car','')" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
	        <%}%>
	        <%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("총무팀남",ck_acar_id) || nm_db.getWorkAuthUser("영업팀내근직",ck_acar_id)){%> 
	        	<%if(bean.getPre_out_yn().equals("Y")){ %>
  	        		<a href="javascript:pre_out_yn('pre_out','','<%=bean.getRent_l_cd()%>');" class="button" onMouseOver="window.status=''; return true" onfocus="this.blur()" style="text-decoration: none; background-color:#FFA2AD;">즉시출고 취소</a>
	        	<%}else{ %>
        			<a href="javascript:pre_out_yn('pre_out','Y','<%=bean.getRent_l_cd()%>');" class="button" onMouseOver="window.status=''; return true" onfocus="this.blur()" style="text-decoration: none;">즉시출고</a>
	        	<%} %>    
	        <%}%>
	      </td>
    </tr>
    <%}else{%>
    <tr>
        <td class=h></td>
    </tr>
    <%}%>
    <% 	//예약1순위자만 계약연동 가능함
    	String rent_sys_bus_id = "";
 	   	String rent_sys_bus_nm = "";
 	   	//동일인이 중복예약은 못함
 	    int res_reg_cnt = 0;
    %>
    <tr>
      	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>예약리스트</span></td>
    </tr>       
     <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                	<td width=3% class=title>연번</td>
		            <td width=5% class=title>예약자</td>
		            <td width=7% class=title>예약자연락처</td>
		            <td width=14% class=title>고객명</td>
		            <td width=10% class=title>고객연락처</td>
		            <td width=10% class=title>주소</td>
		            <td width=10% class=title>메모</td>
		            <td width=8% class=title>예약등록일</td>
		            <td width=12% class=title>예약유효기간</td>		            
		            <td width=8% class=title>예약취소일</td>
		            <td width=5% class=title>수정</td>
		            <td width=8% class=title>심사</td>
                </tr>
			<%for (int i = 0 ; i < vt_size ; i++) {
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if (String.valueOf(ht.get("CLS_DT")).equals("") && rent_sys_bus_id.equals("")) {
					rent_sys_bus_id = String.valueOf(ht.get("REG_ID"));
					rent_sys_bus_nm = String.valueOf(ht.get("BUS_NM"));
				}
				if (String.valueOf(ht.get("CLS_DT")).equals("") && String.valueOf(ht.get("REG_ID")).equals(user_id)) {
					res_reg_cnt++;
				}
				if (String.valueOf(ht.get("CLS_DT")).equals("") && String.valueOf(ht.get("BUS_NM")).equals(session_user_nm)) {
					res_reg_cnt++;
				}				
			%>
                <tr>
                    <td align='center' <%if (!String.valueOf(ht.get("CLS_DT")).equals("")) {%>style="background-color:#CCCCCC;color:#666666;"<%} %>><%=i+1%></td>
                    <td align='center' <%if (!String.valueOf(ht.get("CLS_DT")).equals("")) {%>style="background-color:#CCCCCC;color:#666666;"<%} %>><%=ht.get("BUS_NM")%></td>
                    <td align='center' <%if (!String.valueOf(ht.get("CLS_DT")).equals("")) {%>style="background-color:#CCCCCC;color:#666666;"<%} %>><%=ht.get("BUS_TEL")%></td>
                    <td align='center' <%if (!String.valueOf(ht.get("CLS_DT")).equals("")) {%>style="background-color:#CCCCCC;color:#666666;"<%} %>><%if( !acar_de.equals("1000") || ( acar_de.equals("1000") && String.valueOf(ht.get("BUS_NM")).equals(session_user_nm) ) ){ %><%=ht.get("FIRM_NM")%><%} else{%>***<%}%><%=ht.get("CUST_Q")%></td>
                    <td align='center' <%if (!String.valueOf(ht.get("CLS_DT")).equals("")) {%>style="background-color:#CCCCCC;color:#666666;"<%} %>><%if( !acar_de.equals("1000") || ( acar_de.equals("1000") && String.valueOf(ht.get("BUS_NM")).equals(session_user_nm) ) ){ %><%=ht.get("CUST_TEL")%><%} else{%>***<%}%></td>
                    <td align='center' <%if (!String.valueOf(ht.get("CLS_DT")).equals("")) {%>style="background-color:#CCCCCC;color:#666666;"<%} %>><%if( !acar_de.equals("1000") || ( acar_de.equals("1000") && String.valueOf(ht.get("BUS_NM")).equals(session_user_nm) ) ){ %><%=ht.get("ADDR")%><%} else{%>***<%}%></td>
                    <td align='center' <%if (!String.valueOf(ht.get("CLS_DT")).equals("")) {%>style="background-color:#CCCCCC;color:#666666;"<%} %>><%if( !acar_de.equals("1000") || ( acar_de.equals("1000") && String.valueOf(ht.get("BUS_NM")).equals(session_user_nm) ) ){ %><%=ht.get("MEMO")%><%} else{%>***<%}%><%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("영업팀내근직",ck_acar_id)){%><br><font color=green><%=ht.get("ETC")%></font><%}%></td>
                    <td align='center' <%if (!String.valueOf(ht.get("CLS_DT")).equals("")) {%>style="background-color:#CCCCCC;color:#666666;"<%} %>><%=ht.get("REG_DT")%><%if (!String.valueOf(ht.get("USER_NM")).equals("") && !String.valueOf(ht.get("USER_NM")).equals(String.valueOf(ht.get("BUS_NM")))) {%><br>(<%=ht.get("USER_NM")%>)<%} %></td>
                    <td align='center' <%if (!String.valueOf(ht.get("CLS_DT")).equals("")) {%>style="background-color:#CCCCCC;color:#666666;"<%} %>><%if (!String.valueOf(ht.get("RES_ST_DATE")).equals("")) {%><%=ht.get("RES_ST_DATE")%><%}else{%><%=ht.get("RES_ST_DT")%><%}%>~<%if (!String.valueOf(ht.get("RES_END_DATE")).equals("")) {%><br><%=ht.get("RES_END_DATE")%><%}else{%><%=ht.get("RES_END_DT")%><%}%></td>
                    <td align='center' <%if (!String.valueOf(ht.get("CLS_DT")).equals("")) {%>style="background-color:#CCCCCC;color:#666666;"<%} %>><%=ht.get("CLS_DT")%>
                   	<!--취소-->
                   	<%if (bean.getUse_yn().equals("Y") && String.valueOf(ht.get("CLS_DT")).equals("")) {
                   		res_yn = "Y";
                   		res_cnt++;
                   	%>	
                    	<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("총무팀남",ck_acar_id) || nm_db.getWorkAuthUser("영업팀내근직",ck_acar_id) || String.valueOf(ht.get("REG_ID")).equals(ck_acar_id) || String.valueOf(ht.get("BUS_NM")).equals(session_user_nm) ){%>     
                    	<a href='javascript:dir_update("res_c", <%=ht.get("R_SEQ")%>)'><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a>
                    	<%}%>
                   	<%}%>
                    </td>
                    <!--수정-->
                    <td align='center' <%if (!String.valueOf(ht.get("CLS_DT")).equals("")) {%>style="background-color:#CCCCCC;color:#666666;"<%} %>>
                   	<%if (bean.getUse_yn().equals("Y") && String.valueOf(ht.get("CLS_DT")).equals("") && String.valueOf(ht.get("R_SEQ")).equals(String.valueOf(bean.getR_seq()))) {%>	
                    	<%if (nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("총무팀남",ck_acar_id) || nm_db.getWorkAuthUser("영업팀내근직",ck_acar_id) || String.valueOf(ht.get("REG_ID")).equals(ck_acar_id) || String.valueOf(ht.get("BUS_NM")).equals(session_user_nm) ) {%>     
                    	<a href='javascript:update("res_u", <%=ht.get("R_SEQ")%>)'><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
                    	<%}%>
                   	<%} else {%>
                   		-
                   	<%}%>
                    </td>
                    <!--심사 : 이승엽에이전트 제외-->
                    <td align='center' <%if (!String.valueOf(ht.get("CLS_DT")).equals("")) {%>style="background-color:#CCCCCC;color:#666666;"<%} %>><%=ht.get("CONFIRM_DT")%>
                   	<%if (!bean.getReg_id().equals("000314") && bean.getUse_yn().equals("Y") && String.valueOf(ht.get("DEPT_ID")).equals("1000") && String.valueOf(ht.get("CLS_DT")).equals("") && String.valueOf(ht.get("CONFIRM_DT")).equals("") && String.valueOf(ht.get("R_SEQ")).equals(String.valueOf(bean.getR_seq()))) {%>	
                    	<%if (nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("총무팀남",ck_acar_id) || nm_db.getWorkAuthUser("영업팀내근직",ck_acar_id) || String.valueOf(ht.get("REG_ID")).equals(ck_acar_id) || String.valueOf(ht.get("BUS_NM")).equals(session_user_nm) ) {%>     
                    	<a href='javascript:dir_update("res_conf", <%=ht.get("R_SEQ")%>)'><img src=/acar/images/center/button_in_conf.gif align=absmiddle border=0></a>
                    	<%}%>
                   	<%} else {%>
                   		-
                   	<%}%>
                    </td>
                </tr>
			<%}%>                
            </table>
        </td>
    </tr> 
    <%if (bean.getUse_yn().equals("Y") && res_cnt < 3 && res_reg_cnt==0) {  //res_yn.equals("N")%>
    <tr>
	    <td align="right">
        <input type="button" class="button" id="res_reg" value='예약 등록' onclick="javascript:update('res_i', '');">
	    </td>
    </tr>    
    <%}%>
    <%if (res_reg_cnt > 0) { %>
    <tr>
	    <td align="right">
        ※ 동일인이 중복 예약할 수 없습니다. 
	    </td>
    </tr>    
    <%}%>
    <tr>
        <td class=h></td>
    </tr>
    <%
  		//계약등록 확인
		Hashtable cont = a_db.getContCase(bean.getRent_l_cd());
	
		//계약기본정보
		ContBaseBean base = a_db.getCont(String.valueOf(cont.get("RENT_MNG_ID")), bean.getRent_l_cd());
		
		// 에이전트의 경우 접속자가 최초영업자가 아니면 계약 연동 항목 노출시키지 않음. 21.10.28.
		// 연동된 계약이 없는 경우에도 노출. 21.12.14.
    	if( bean.getRent_l_cd().equals("") || !acar_de.equals("1000") || ( acar_de.equals("1000") && session_user_nm.equals(c_db.getNameById(base.getBus_id(),"USER")) ) ){ 
    %>
    <tr>
      	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약연동</span></td>
    </tr>      
    <%if (bean.getRent_l_cd().equals("")) {%>
    <tr>
        <td>※ 연동된 계약이 없습니다.
        	<%//if(vt_size >0 && bean.getUse_yn().equals("Y")){%>
        	<%if((nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("총무팀남",ck_acar_id) || nm_db.getWorkAuthUser("영업팀내근직",ck_acar_id) || rent_sys_bus_id.equals(ck_acar_id) || rent_sys_bus_nm.equals(session_user_nm)) && bean.getUse_yn().equals("Y")){ //1순위예약자만 계약연동 가능%>
        	&nbsp;&nbsp;&nbsp;&nbsp;
        	<input type="button" class="button" id="pre_cont" value='계약연동' onclick="javascript:update('cont', '');">	
        	<%}%>
        </td>
    </tr>    
    <%} else {
			//계약등록 확인
// 			Hashtable cont = a_db.getContCase(bean.getRent_l_cd());
			
			//계약기본정보
// 			ContBaseBean base = a_db.getCont(String.valueOf(cont.get("RENT_MNG_ID")), bean.getRent_l_cd());

			//계약기타정보
			ContEtcBean cont_etc = a_db.getContEtc(base.getRent_mng_id(), base.getRent_l_cd());

			//신차대여정보
			ContFeeBean fee = a_db.getContFeeNew(base.getRent_mng_id(), base.getRent_l_cd(), "1");
			
			//고객정보
			ClientBean client = al_db.getNewClient(base.getClient_id());
			
			//출고정보
			ContPurBean pur = a_db.getContPur(base.getRent_mng_id(), base.getRent_l_cd());
			
			//영업,출고사원
			Hashtable mgrs = a_db.getCommiNInfo(base.getRent_mng_id(), base.getRent_l_cd());
			Hashtable mgr_bus = (Hashtable)mgrs.get("BUS");
			Hashtable mgr_dlv = (Hashtable)mgrs.get("DLV");
			
			//차량기본정보
			ContCarBean car 	= a_db.getContCarNew(base.getRent_mng_id(), base.getRent_l_cd());

			//자동차기본정보
			CarMstBean cm_bean = cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());	
			
			a_rent_l_cd = bean.getRent_l_cd();
			a_firm_nm = client.getFirm_nm();
			a_dlv_ext = pur.getDlv_ext();
			a_udt_st = pur.getUdt_st();
    %>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=7% style="font-size : 8pt;">계약번호</td>
                    <td width=14%>&nbsp;<%=bean.getRent_l_cd()%></td>
                    <td width=7% class='title' style="font-size : 8pt;">상호/성명</td>
       		        <td >&nbsp;<b><font color='#990000'><%=client.getFirm_nm()%></font></b>&nbsp;<%if(!client.getClient_st().equals("2")){%><%=client.getClient_nm()%><%}%></td>
                    <td width=7% class='title' style="font-size : 8pt;">출고영업소</td>
       		        <td width=18%>&nbsp;<%=mgr_dlv.get("COM_NM")%>&nbsp;<%=mgr_dlv.get("CAR_OFF_NM")%></td>
                    <td width=7% class='title' style="font-size : 8pt;">계출번호</td>
       		        <td width=10%>&nbsp;<%=pur.getRpt_no()%></td>
                </tr>
                <tr>
                    <td class=title style="font-size : 8pt;">계약일자</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title width=7% style="font-size : 8pt;">최초영업</td>
                    <td width=10%>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
                    <td class=title style="font-size : 8pt;">출고지</td>
                    <td>&nbsp;<%=pur.getDlv_ext()%></td>
                    <td class=title width=7% style="font-size : 8pt;">인수지</td>
                    <td width=10%>&nbsp;<%if(pur.getUdt_st().equals("1") ){%>서울본사<%}%><%if(pur.getUdt_st().equals("2")){%>부산지점<%}%><%if(pur.getUdt_st().equals("3")){%>대전지점<%}%><%if(pur.getUdt_st().equals("4")){%>고객<%}%><%if(pur.getUdt_st().equals("5")){%>대구지점<%}%><%if(pur.getUdt_st().equals("6")){%>광주지점<%}%></td>
                </tr>
                <tr>
                    <td width=7% class=title style="font-size : 8pt;">차명</td>
                    <td colspan='7' width=13%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></td>
                </tr>
                <tr>
                    <td class=title style="font-size : 8pt;">옵션</td>
                    <td colspan='7'>&nbsp;<%=car.getOpt()%></td>
                </tr>
                <tr>
                    <td class=title style="font-size : 8pt;">색상</td>
                    <td colspan='7'>&nbsp;외장:<%=car.getColo()%>&nbsp;내장:<%=car.getIn_col()%>&nbsp;가니쉬:<%=car.getGarnish_col()%></td>
                </tr>
                <tr>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
	    <td align="center">
        <%if (bean.getUse_yn().equals("Y")) {%>                
	        <%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("총무팀남",ck_acar_id) || nm_db.getWorkAuthUser("영업팀내근직",ck_acar_id) || base.getBus_id().equals(ck_acar_id) || base.getReg_id().equals(ck_acar_id) ){%>     
				<input type="button" class="button" id="pre_cls" value='계약연동 취소' onclick="javascript:dir_update('no_cont', '');">
	        <%}%>        
        <%}%>	    	
	    </td>
    </tr>
    <%}%>
    <%}%>
    
    <tr>
	    <td align="center">
        <%if (bean.getUse_yn().equals("Y") && res_yn.equals("N")) {%>
	        <%if (nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("총무팀남",ck_acar_id) || nm_db.getWorkAuthUser("영업팀내근직",ck_acar_id) ) {%>     
	                <input type="button" class="button" id="pre_cls" value='사전계약 해지' onclick="javascript:dir_update('cls', '');">
	        <%}%>
        <%}%>	    	
	    </td>
    </tr>
    <%if (bean.getUse_yn().equals("Y") && res_yn.equals("Y")) {%>
    <tr>
	    <td>※ 예약자가 있으면 사전계약 해지를 할 수 없습니다.</td>
    </tr>
    <%}%>
    <%if (bean.getUse_yn().equals("Y") && !bean.getRent_l_cd().equals("")) {%>
    <tr>
	    <td>※ 계약연동이 있으면 사전계약 해지를 할 수 없습니다.</td>
    </tr>
    <%}%>
    
    <!-- 자체출고관리 확인 -->
    <%if (!cpd_bean.getRent_l_cd().equals("")) {
    
    	//계약기본정보
		ContBaseBean base2 = a_db.getCont(cpd_bean.getRent_mng_id(), cpd_bean.getRent_l_cd());
    	//출고정보
		ContPurBean pur2 = a_db.getContPur(cpd_bean.getRent_mng_id(), cpd_bean.getRent_l_cd());
		//고객정보
		ClientBean client2 = al_db.getNewClient(base.getClient_id());
		
		b_rent_l_cd = cpd_bean.getRent_l_cd();
		b_firm_nm = client2.getFirm_nm();
		b_dlv_ext = cpd_bean.getDlv_ext();
		b_udt_st = cpd_bean.getUdt_st();
    %>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><font color=red>자체출고관리</font></span></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title>계약번호</td>
                    <td>&nbsp;<%=cpd_bean.getRent_l_cd()%></td>
                    <td class=title>계출번호</td>
                    <td>&nbsp;<%=cpd_bean.getCom_con_no()%></td>
                    <td class=title>등록일자</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate10(cpd_bean.getReg_dt())%></td>                                        
                    <td class=title>출고희망일</td>
                    <td width=7%>&nbsp;<%=AddUtil.ChangeDate2(pur2.getPur_req_dt())%></td>
                    <td class=title>상호</td>
                    <td>&nbsp;
                    <% if( !acar_de.equals("1000") || ( acar_de.equals("1000") && session_user_nm.equals(c_db.getNameById(base2.getBus_id(),"USER")) ) ){%>
                    <%=pur2.getPur_com_firm()%>                        
                        <%if(pur2.getPur_com_firm().equals("")){%>
                            <%=client2.getFirm_nm()%>
                        <%}else{%>
                            &nbsp;<%=AddUtil.ChangeEnt_no(c_db.getNameById(pur2.getPur_com_firm(),"ENP_NO"))%>
                        <%}%>
                    <%} else{%>
                    	***
                    <%}%>
                    </td>
                    <td class=title>영업담당자</td>
                    <td>&nbsp;
                    <%if( !acar_de.equals("1000") || ( acar_de.equals("1000") && session_user_nm.equals(c_db.getNameById(base2.getBus_id(),"USER")) ) ){ %>
                    <%=c_db.getNameById(base2.getBus_id(),"USER")%>
                    <%	if(!base2.getAgent_emp_id().equals("")){
                    		CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base2.getAgent_emp_id());
                    %>
                    		(에이전트 계약진행담당자 : <%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%>)
                    <%	}%>  
                    <%} else{%>
                    	***
                    <%}%>
                    </td>
    		    </tr>
    		    <tr> 
                    <td class=title>배정구분</td>
                    <td>&nbsp;<b>[<%if(cpd_bean.getDlv_st().equals("1")){%>예정<%}%><%if(cpd_bean.getDlv_st().equals("2")){%>배정<%}%>]</b></td>
                    <td class=title>예정일자</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(cpd_bean.getDlv_est_dt())%></td>
                    <td class=title>배정일자</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(cpd_bean.getDlv_con_dt())%></td>
                    <td class=title>출고사무소</td>
                    <td>&nbsp;
                    <%	if(!a_dlv_ext.equals("") && !b_dlv_ext.equals("") && !a_dlv_ext.equals(b_dlv_ext)){ %><span style="font-size: 15px; font-weight:bold;"><%} %>
                    <%=cpd_bean.getDlv_ext()%>
                    <%	if(!a_dlv_ext.equals("") && !b_dlv_ext.equals("") && !a_dlv_ext.equals(b_dlv_ext)){ %></span><%} %>
                    </td>
                    <td class=title>배달지구분</td>
                    <td>&nbsp;
                    <%	if(!a_udt_st.equals("") && !b_udt_st.equals("") && !a_udt_st.equals(b_udt_st)){ %><span style="font-size: 15px; font-weight:bold;"><%}%>
                    <%if(cpd_bean.getUdt_st().equals("1") ){%>서울본사<%}%><%if(cpd_bean.getUdt_st().equals("2")){%>부산지점<%}%><%if(cpd_bean.getUdt_st().equals("3")){%>대전지점<%}%><%if(cpd_bean.getUdt_st().equals("4")){%>고객<%}%><%if(cpd_bean.getUdt_st().equals("5")){%>대구지점<%}%><%if(cpd_bean.getUdt_st().equals("6")){%>광주지점<%}%>
                    <%	if(!a_udt_st.equals("") && !b_udt_st.equals("") && !a_udt_st.equals(b_udt_st)){ %></span><%}%>
                    </td>
                    <td class=title>배달지</td>
                    <td>&nbsp;<%=cpd_bean.getUdt_firm()%></td>
    		    </tr>
            </table>
        </td>
    </tr> 
    <%} %>
    
    
    <%if(!a_rent_l_cd.equals("") && !b_rent_l_cd.equals("")){ %>
    
    <%	if(!a_rent_l_cd.equals(b_rent_l_cd)){ %>
    <tr>
	    <td><span style="font-size: 15px; font-weight:bold;"><font color=red>※ 사전계약연동 계약번호와 자체출고연동 계약번호가 다릅니다.</font></span></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <%	} %>
    
    <%	if(!a_firm_nm.equals(b_firm_nm)){ %>
    <tr>
	    <td><span style="font-size: 15px; font-weight:bold;"><font color=red>※ 사전계약연동 고객과 자체출고연동 고객이 다릅니다.</font></span></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <%	} %>
    
    <%	if(!a_dlv_ext.equals("") && !b_dlv_ext.equals("") && !a_dlv_ext.equals(b_dlv_ext)){ %>
    <tr>
	    <td><span style="font-size: 15px; font-weight:bold;"><font color=red>※ 사전계약연동 출고지와 자체출고연동 출고지가 다릅니다.</font></span></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <%	} %>
    
    <%	if(!a_udt_st.equals("") && !b_udt_st.equals("") && !a_udt_st.equals(b_udt_st)){ %>
    
    <%		if(bean.getCar_off_nm().equals("B2B사업운영팀") || cpd_bean.getCar_off_id().equals("03900")){ %>
    <tr>
	    <td><span style="font-size: 25px; font-weight:bold;"><font color=red>※ 배달지가 다릅니다. 배정처리가 된 후 배정후변경(협력업체관리 > 자체출고관리 > 배정현황)으로 배달지 변경하시기 바랍니다. </font></span></td>
    </tr>    
    <%		}else{ %>
    <tr>
	    <td><span style="font-size: 15px; font-weight:bold;"><font color=red>※ 사전계약연동 계약 인수지와 자체출고연동 배달지(인수지)가 다릅니다. 자체출고에서 배달지를 변경하십시오. 미변경시 차량대금지급요청시 문서기안시 인수지로 자동변경 처리가 됩니다.</font></span></td>
    </tr>
    <%		} %>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <%	} %>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <%} %>
    
    
    
    <%if (bean.getUse_yn().equals("N")) {%>
    <%if (nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("총무팀남",ck_acar_id) || nm_db.getWorkAuthUser("영업팀내근직",ck_acar_id) ) {%> 
    <tr>
	    <td align="center">
	    	<input type="button" class="button" value="진행중으로 복구" onclick="javascript:restore_pre_cont();">
	    </td>
    </tr>
    	<%}%>
    <%}%>
    <%if (mode.equals("view")) {%>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	    <td align="right"><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    <tr>
    <%}%>
    
</table>
</form>
<script language="JavaScript">
<!--
	
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

