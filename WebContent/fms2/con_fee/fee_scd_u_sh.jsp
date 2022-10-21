<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.common.*, acar.car_mst.*, acar.client.*, acar.car_mst.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 	= request.getParameter("asc")==null?"":request.getParameter("asc");
	String f_list 	= request.getParameter("f_list")==null?"scd":request.getParameter("f_list");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String reg_yn 	= request.getParameter("reg_yn")==null?"":request.getParameter("reg_yn");
	String gubun	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//대여갯수 카운터
	int fee_count = af_db.getFeeCount(l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
			
	//출고지연대차
	ContTaechaBean taecha = a_db.getTaecha(m_id, l_cd, taecha_no);
	
	
	//기존대여스케줄 대여횟수 최대값
	int max_fee_tm = a_db.getMax_fee_tm(m_id, l_cd, rent_st);
	
	//지연대차 스케줄 대여횟수 최대값
	int max_taecha_tm = a_db.getMax_fee_tm(m_id, l_cd, "");
	
	//고객정보
	ClientBean client = al_db.getNewClient(String.valueOf(base.get("CLIENT_ID")));
	
	//계약기본정보
	ContBaseBean c_base = a_db.getCont(m_id, l_cd);
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(m_id, l_cd);
	//계약승계 혹은 차종변경일때 원계약 해지내용
	Hashtable begin = a_db.getContBeginning(m_id, c_base.getReg_dt());
	//계약승계 혹은 차종변경일때 승계계약 해지내용
	Hashtable cng_cont = af_db.getScdFeeCngContA(m_id, l_cd);
	
	//차량기본정보
	ContCarBean car = a_db.getContCarNew(m_id, l_cd);	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_to_list(){
		var fm = document.form1;	
		fm.action='fee_scd_frame.jsp';		
		if(fm.from_page.value=='/fms2/con_fee/scd_cng_frame.jsp'){
			fm.action='scd_cng_frame.jsp';		
		}else if(fm.from_page.value=='/fms2/con_fee/fee_scd_rm_frame.jsp'){
			fm.action='fee_scd_rm_frame.jsp';		
		}
		<%if(c_base.getCar_st().equals("4")){%>
		fm.action='fee_scd_rm_frame.jsp';		
		<%}%>
		fm.target='d_content';
		fm.submit();	
	}
	
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}	
	function view_car(m_id, l_cd, c_id)
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&car_mng_id="+c_id+"&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		
		
	function fee_scd_in(gubun){
		var fm = document.form1;	
		if(gubun == '0'){
			fm.gubun.value = "지연";
		}else{
			fm.gubun.value = "신차";		
			fm.rent_st.value = gubun;
		}
//		fm.action='fee_scd_u_sc.jsp';		
//		fm.target='d_body';
		fm.action='fee_scd_u_frame.jsp';				
		fm.target='d_content';
		fm.submit();	
	}
	
	function search(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == '1') fm.t_wd.value = fm.s_firm_nm.value;
		if(s_kd == '2') fm.t_wd.value = fm.s_rent_l_cd.value;
		if(s_kd == '3') fm.t_wd.value = fm.s_car_no.value;	
		if(fm.t_wd.value == ''){ alert('검색할 단어를 입력하십시오.'); return; }			
		window.open("about:blank", "SEARCH", "left=50, top=50, width=880, height=520, scrollbars=yes");				
		fm.action = "fee_scd_sc.jsp";
		<%if(c_base.getCar_st().equals("4")){%>
		fm.action='fee_scd_rm_sc.jsp';		
		<%}%>
		fm.target = "SEARCH";
		fm.submit();
	}	
	function enter(s_kd){
		var keyValue = event.keyCode;
		if (keyValue =='13') search(s_kd);
	}
	//스케줄변경이력
	function FeeScdCngList(){
		var fm = document.form1;
		window.open("about:blank", "ScdCngList", "left=50, top=50, width=900, height=600, scrollbars=yes");				
		fm.action = "fee_scd_u_cnglist.jsp";
		fm.target = "ScdCngList";
		fm.submit();	
	}	
	//대여료납입안내문
	function FeeScdDoc(){
		var fm = document.form1;
		window.open("about:blank", "ScdDoc", "left=50, top=50, width=700, height=650, scrollbars=yes");				
		fm.action = "fee_scd_doc.jsp";
		fm.target = "ScdDoc";
		fm.submit();
	}
	//대여료납입안내문
	function FeeScdDocEmail(){
		var fm = document.form1;
		window.open("about:blank", "ScdDocEmail", "left=50, top=50, width=700, height=450, scrollbars=yes");				
		fm.action = "fee_scd_email_reg.jsp";
		fm.target = "ScdDocEmail";
		fm.submit();
	}		
	//계산서일시중지관리
	function FeeScdStop(){
		var fm = document.form1;
		window.open("about:blank", "ScdStopList", "left=50, top=50, width=850, height=700, scrollbars=yes");				
		fm.action = "fee_scd_u_stoplist.jsp";
		fm.target = "ScdStopList";
		fm.submit();
	}
	
	//거래처 최근 발행예정일 보기
	function clientFeeReqDt(client_id){
		window.open("client_feereqdt.jsp?client_id="+client_id, "clientFeeReqDt", "left=100, top=100, width=900, height=700, scrollbars=yes");
	}	
	
	//특이사항 수정
	function see_etc()
	{
		var fm = document.form1;
		var m_id = fm.m_id.value;
		var l_cd = fm.l_cd.value;
		var c_id = fm.c_id.value;						
		var st = 'mgr';				
		var client_id = fm.client_id.value;
		var etc = fm.etc.value;
		var firm_nm = fm.firm_nm.value;
		var client_nm = fm.client_nm.value;	
		var auth 	= fm.auth.value;		
		var auth_rw = fm.auth_rw.value;
		var user_id = fm.user_id.value;			
		var br_id	= fm.br_id.value;						
		var gubun1 	= fm.gubun1.value;
		var gubun2 	= fm.gubun2.value;
		var gubun3 	= fm.gubun3.value;
		var gubun4 	= fm.gubun4.value;		
		var st_dt 	= fm.st_dt.value;
		var end_dt 	= fm.end_dt.value;
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var sort_gubun = fm.sort_gubun.value;
		var asc 	= fm.asc.value;					
		var f_list 	= fm.f_list.value;							
		window.open("/fms2/con_fee/etc_s_p.jsp?m_id="+m_id+"&l_cd="+l_cd+"&st="+st+"&client_id="+client_id+"&etc="+etc+"&firm_nm="+firm_nm+"&client_nm="+client_nm+"&auth="+auth+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc+"&f_list="+f_list, "ETC", "left=100, top=100, width=520, height=250");
	}		
	
	//스캔관리 보기
	function view_scan(){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, scrollbars=yes");		
	}
	
	//전체이용차량리스트
	function list_view() {
		window.open("/acar/car_rent/scd_fee_rent_list.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>", "print_view", "left=100, top=100, width=1300, height=700, scrollbars=yes");
	}	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
.button_style {
	background-image: linear-gradient(#919191, #787878);
    font-size: 10px;
    font-weight: bold;
    cursor: pointer;
    border-radius: 3px;
    color: #FFF;
    border: 0;
    outline: 0;
    padding: 5px 8px;
    margin: 3px;
}
</style>
</head>
<body>

<form name='form1' action='' target='' method="post">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='reg_yn' value='<%=reg_yn%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<input type='hidden' name='f_list' value='scd'>
<input type='hidden' name='etc' value='<%=client.getEtc()%>'>
<input type='hidden' name='client_id' value='<%=client.getClient_id()%>'>
<input type='hidden' name='firm_nm' value='<%=client.getFirm_nm()%>'>
<input type='hidden' name='client_nm' value='<%=client.getClient_nm()%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td colspan=5>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계출관리 > 대여료스케줄관리 > <span class=style5>등록</span></span></td>
                    <td class=bar style='text-align:right'>&nbsp;<font color="#996699">
            	    <%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계")){%>[계약승계] 원계약 : <%=begin.get("RENT_L_CD")%> <%=begin.get("FIRM_NM")%>, 승계일자 : <%=cont_etc.getRent_suc_dt()%><%if(cont_etc.getRent_suc_dt().equals("")){%><%=begin.get("CLS_DT")%><%}%> <%}%>
            	    <%if(String.valueOf(begin.get("CLS_ST")).equals("차종변경")){%>[차종변경] 원계약 : <%=begin.get("RENT_L_CD")%> <%=begin.get("CAR_NO")%>&nbsp;<%=begin.get("CAR_NM")%>, 변경일자 : <%=begin.get("CLS_DT")%><%}%>            	    
					
					<%if(String.valueOf(cng_cont.get("CLS_ST")).equals("5")){%>[계약승계] 승계계약 : <%=cng_cont.get("RENT_L_CD")%> <%=cng_cont.get("FIRM_NM")%>, 승계일자 : <%if(String.valueOf(cng_cont.get("RENT_SUC_DT")).equals("")){%><%=cng_cont.get("CLS_DT")%><%}else{%><%=cng_cont.get("RENT_SUC_DT")%><%}%> <%if(!String.valueOf(cng_cont.get("RENT_SUC_DT")).equals("") && !String.valueOf(cng_cont.get("RENT_SUC_DT")).equals(String.valueOf(cng_cont.get("CLS_DT")))){%>, 해지일자 : <%=cng_cont.get("CLS_DT")%><%}%> <%}%>
					<%if(String.valueOf(cng_cont.get("CLS_ST")).equals("4")){%>[차종변경] 변경계약 : <%=cng_cont.get("RENT_L_CD")%> <%=cng_cont.get("FIRM_NM")%>, 변경일자 : <%=cng_cont.get("CLS_DT")%> <%}%>					
					</font>&nbsp;
					</td>					
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>  
    <tr>
        <td align=right colspan="2"><a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a></td>
    </tr>	
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>	
	<tr>
        <td colspan="2" class='line'>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='10%' class='title'>계약번호</td>
                    <td width='23%'>&nbsp;<input type='text' name='s_rent_l_cd' value='<%=base.get("RENT_L_CD")%>' size='20' class='text' onKeyDown='javascript:enter(2)' style='IME-MODE: inactive'>(<%=base.get("RENT_MNG_ID")%>)</td>
                    <td width='10%' class='title'>상호</td>
                    <td>&nbsp;<input type='text' name='s_firm_nm' value='<%=base.get("FIRM_NM")%>' size='50' class='text' onKeyDown='javascript:enter(1)' style='IME-MODE: active'>
        		    <%=base.get("R_SITE_NM")%>
        		    <a href="javascript:view_client('<%=m_id%>', '<%=l_cd%>', '1')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
					(<%=base.get("CLIENT_ID")%>)
        		    </td>
                </tr>
                <tr>
                     <td class='title'>차량번호</td>
                     <td>&nbsp;<input type='text' name='s_car_no' value='<%=base.get("CAR_NO")%>' size='20' class='text' onKeyDown='javascript:enter(3)' style='IME-MODE: active'></td>
                     <td class='title'>차명</td>
                     <td>&nbsp;
                     	[<%=cm_bean.getJg_code()%>]
                     		<span title='<%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%>'><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span>
        			 <a href="javascript:view_car('<%=m_id%>', '<%=l_cd%>', '<%=c_id%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
        			  </td>
                </tr>
                <tr>
                     <td class='title'> 대여방식 </td>
                     <td>&nbsp;<%=base.get("RENT_WAY")%></td>
                     <td class='title'>CMS</td>
                     <td>
        			    &nbsp;<%if(!cms.getCms_bank().equals("")){%>
						<b>
								<%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%>
								</b>
        			 	<%=cms.getCms_bank()%> <%=cms.getCms_acc_no()%> <%=cms.getCms_dep_nm()%>: <%=AddUtil.ChangeDate2(cms.getCms_start_dt())%> ~ <%=AddUtil.ChangeDate2(cms.getCms_end_dt())%> (매월 <%=cms.getCms_day()%>일)
        			 	<%}else{%>
        			 	-
        			 	<%}%>			 
        			 </td>
                </tr>
                <tr>
                     <td class='title'>영업담당자</td>
                     <td>&nbsp;<%=c_db.getNameById(String.valueOf(base.get("BUS_ID2")),"USER")%>
					 <%if(String.valueOf(base.get("USE_YN")).equals("N")){%>
					 &nbsp;해지일자 : <%=base.get("CLS_DT")%>, 해지구분 : <%=base.get("CLS_ST")%>  
					 <%}%>
					 </td>
                     <td class='title'>관리담당자</td>
                     <td>&nbsp;<%=c_db.getNameById(String.valueOf(base.get("MNG_ID")),"USER")%>
					 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					 <font color='#999999'>(계산서발행구분:
					  <%if(client.getPrint_st().equals("1")){ 		out.println("계약건별");
					  }else if(client.getPrint_st().equals("2")){   out.println("<font color='#FF9933'>거래처통합</font>");
					 }else if(client.getPrint_st().equals("3")){ 	out.println("<font color='#FF9933'>지점통합</font>");
					 }else if(client.getPrint_st().equals("4")){	out.println("<font color='#FF9933'>현장통합</font>"); }%>
                     	                        , 계산서별도발행구분:
                     	                        <%  if(client.getPrint_car_st().equals("1")){	out.println("승합/화물/9인승/경차");
                     	                        }else{		out.println("없음"); }
                     				%>
						, 전자세금계산서구분:
						<%if(cont_etc.getEle_tax_st().equals("1")){ 		out.println("당사시스템");
								}else if(cont_etc.getEle_tax_st().equals("2")) {  out.println("<font color='#FF9933'>별도시스템-"+cont_etc.getTax_extra()+"</font>"); }%>						
						)
						</font>
					 </td>
                </tr>		   
                <tr>
                     <td class='title'>고객 특이사항</td>
                     <td colspan='3'>&nbsp;<%=Util.htmlBR(client.getEtc())%></td>                     
					 </td>
                </tr>		   				
            </table>
	    </td>
	</tr>
	<tr>
	    <td>
	  	  <%if(max_taecha_tm >0 || (!taecha.getRent_mng_id().equals("") && taecha.getReq_st().equals("1") && taecha.getTae_st().equals("1"))){%>
		  <a href="javascript:fee_scd_in('0')"><img src=/acar/images/center/button_dcdy.gif  align=absmiddle border="0"></a>&nbsp;&nbsp;
		  <%}%>
		  <%for(int i=0; i<fee_count; i++){%>
		  <%	if(i==0){%>
		  <a href="javascript:fee_scd_in('<%=i+1%>')"><img src=/acar/images/center/button_ncar.gif align=absmiddle border="0"></a>
		  <%	}else{%>
		  <input type="button" class="button_style" id="fee_scd_in_button" value="<%=i%>차 연장대여" onclick="fee_scd_in('<%=i+1%>');">
		  <%	}%>
		  <%}%>
		  
		  &nbsp;&nbsp;
		   &nbsp; 
		  <a href="javascript:list_view();"><img src="/acar/images/center/button_all_car.png" align="absmiddle" border="0"></a>&nbsp;
	    </td>
	    <td align="right">
	    <input type='hidden' name='fee_count' value='<%=fee_count%>'>
	    <input type='hidden' name='max_fee_tm' value='<%=max_fee_tm%>'>	  
	    <%if(fee_count > 0 && max_fee_tm > 2){%>
	    <img src=/acar/images/center/arrow.gif> 대여료납입안내문 [ <a href="javascript:FeeScdDoc()"><img src=/acar/images/center/button_in_print.gif  align=absmiddle border="0"></a> / <a href="javascript:FeeScdDocEmail()"><img src=/acar/images/center/button_in_email.gif  align=absmiddle border="0"></a> ]&nbsp;&nbsp;	  
	     <a href="javascript:FeeScdStop()"><img src=/acar/images/center/button_ncha.gif  align=absmiddle border="0"></a>&nbsp;&nbsp;
	    <%}%>	    
		<a href="javascript:clientFeeReqDt('<%=base.get("CLIENT_ID")%>')"><img src=/acar/images/center/button_conf_bh.gif align=absmiddle border="0"></a>&nbsp;&nbsp;
	        <a href="javascript:FeeScdCngList()"><img src=/acar/images/center/button_scd_bgir.gif  align=absmiddle border="0"></a>&nbsp;&nbsp;
		<a href="javascript:see_etc()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify_e.gif align=absmiddle border="0"></a>&nbsp;&nbsp; 
		<a href ="javascript:view_scan()"><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>
		</td>
	</tr>
	<tr>
	    <td></td>
	</tr>
	<tr>
	    <td colspan="2" style="background-color:#d2d2d2; height:1"></td>	
	</tr>		
</table>
</form>
</body>
</html>
