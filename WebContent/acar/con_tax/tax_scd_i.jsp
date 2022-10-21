<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.con_tax.*, acar.car_mst.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String est_mon = request.getParameter("est_mon")==null?"":request.getParameter("est_mon");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String car_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String cls_st 	= request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	String tax_st 	= request.getParameter("tax_st")==null?"":request.getParameter("tax_st");
	String rent_mon	= request.getParameter("rent_mon")==null?"":AddUtil.replace(request.getParameter("rent_mon"), " ", "");
	String dlv_mon	= request.getParameter("dlv_mon")==null?"":AddUtil.replace(request.getParameter("dlv_mon"), " ", "");
	String tax_come_dt	= request.getParameter("tax_come_dt")==null?"":AddUtil.replace(request.getParameter("tax_come_dt"), " ", "");
	String f_list 	= request.getParameter("f_list")==null?"":request.getParameter("f_list");
	String reg_ok = "";
	String cau = "";
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "03", "12");
	
	
	//계약정보
	Hashtable cont = t_db.getAllotByCase(m_id, l_cd);
	//기타정보
	Hashtable tax = t_db.getTaxScdInfo(m_id, l_cd);
	
	String ssn = AddUtil.ChangeEnpH(String.valueOf(cont.get("ENP_NO")));	
	
	if(AddUtil.parseInt(String.valueOf(tax.get("DPM"))) <= 800){
	    reg_ok = "N";
	    cau = "800cc 이하 경차";
	}else{
		if(tax_st.equals("장기대여") && !f_list.equals("pay")){// 
			if(l_cd.substring(7,8).equals("S")){
				reg_ok = "N";
				cau = "매각처리가 안된 차량";
			}else{
				if(String.valueOf(cont.get("CAR_ST")).equals("3")){
					reg_ok = "N";
					cau = "리스 차량";
				}else if(String.valueOf(cont.get("CAR_NAME")).indexOf("9인승") != -1 || String.valueOf(cont.get("CAR_NAME")).indexOf("12인승") != -1){ // && AddUtil.parseInt(String.valueOf(cont.get("DPM"))) < 2000
					reg_ok = "N";
					cau = "7인승이상 차량";
				}else if(!l_cd.substring(7,8).equals("S") && AddUtil.parseInt(rent_mon) < 12){
					reg_ok = "N";
					cau = "장기대여개시 12개월 미도래 차량 ("+AddUtil.parseInt(rent_mon)+")";
//				}else if(AddUtil.parseInt(String.valueOf(cont.get("RENT_START_DT"))) < 20020101 || AddUtil.parseInt(String.valueOf(cont.get("CONT_DT"))) < 20020101){
//					reg_ok = "N";
//					cau = "개별소비세 적용전 차량";
				}
			}
		}
	}
	
	String dlv_year = "";
	String migr_year = "";
	String cha_year = "";
	if(!String.valueOf(cont.get("DLV_DT")).equals("")) 	dlv_year = String.valueOf(cont.get("DLV_DT")).substring(0,4);
	if(tax_st.equals("용도변경")){
		cha_year = tax_come_dt.substring(0,4);;
	}
	
	if(tax_st.equals("매각")){
//		int dlv_year = t_db.getDlv_year((String)cont.get("DLV_DT"));
		if(String.valueOf(cont.get("MIGR_DT")).length() > 4) migr_year = String.valueOf(cont.get("MIGR_DT")).substring(0,4);
		if((AddUtil.parseInt(migr_year)-AddUtil.parseInt(dlv_year)) > 5){
			reg_ok = "N";
			cau = "출고일자로 부터 5년이 경과된 차량";
		}
	}
	
	if(tax_come_dt.equals("")) tax_come_dt = String.valueOf(cont.get("TAX_COME_DT"));
		
	
	//회계처리일자
	String V_EST_DT = rs_db.addMonth(tax_come_dt, 1); //납부사유발생일자 다음달
	int v_est_yy = AddUtil.parseInt(AddUtil.replace(V_EST_DT,"-","").substring(0,4));
	int v_est_mm = AddUtil.parseInt(AddUtil.replace(V_EST_DT,"-","").substring(4,6));
	int v_est_dd = AddUtil.getMonthDate(v_est_yy, v_est_mm);
	String yymm_maxday = String.valueOf(v_est_dd);	
	V_EST_DT = AddUtil.replace(V_EST_DT,"-","").substring(0,6)+""+yymm_maxday;
	
	out.println("회계처리일자="+V_EST_DT);
	
	//분기납부예정일자	
	String V_EST_DT2 = "";
	if(v_est_mm == 2 || v_est_mm == 5 || v_est_mm == 8 || v_est_mm == 11){
        	V_EST_DT2 = rs_db.addMonth(tax_come_dt, 2);
	}else if(v_est_mm == 3 || v_est_mm == 6 || v_est_mm == 9 || v_est_mm == 12){
                V_EST_DT2 = rs_db.addMonth(tax_come_dt, 1);
	}else if(v_est_mm == 4 || v_est_mm == 7 || v_est_mm == 10 || v_est_mm == 1){
                V_EST_DT2 = V_EST_DT;
	}
	V_EST_DT2 = AddUtil.replace(V_EST_DT2,"-","").substring(0,6)+"25";
	
	out.println("분기납부예정일자="+V_EST_DT2);
	
	out.println("dlv_mon="+String.valueOf(cont.get("DLV_MON")));

		
	String tax_rate = t_db.getTaxRate("특소세", (String)tax.get("DPM"), tax_come_dt);
	String sur_rate = t_db.getSurRate200812(String.valueOf(cont.get("DLV_MON")));
	
	if(AddUtil.parseInt(AddUtil.replace(String.valueOf(cont.get("DLV_DT")),"-","")) >= 20140101){
		sur_rate = "100";
	}
	
	int tax_reg_count = t_db.getTaxRegCount(car_id);
	
	//자동차회사&차종&자동차명
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
	
	
	
	//개별소비세세율인하
//	if(AddUtil.parseInt(AddUtil.replace(String.valueOf(cont.get("DLV_DT")),"-","")) >= 20081219 && AddUtil.parseInt(AddUtil.replace(String.valueOf(cont.get("DLV_DT")),"-","")) <= 20090630){
	if(AddUtil.parseInt(AddUtil.replace(tax_come_dt,"-","")) >= 20081219 && AddUtil.parseInt(AddUtil.replace(tax_come_dt,"-","")) <= 20090630){
		out.println("개별소비세세율인하");
		if(AddUtil.parseFloat(tax_rate) == 5) 			tax_rate = "3.5";
		else if(AddUtil.parseFloat(tax_rate) == 10) 		tax_rate = "7";
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(){
		var fm = document.form1;
		if(fm.tax_st.value == ''){ alert("환입구분을 입력하십시오"); return; }
		if(fm.cls_man_st.value == '' && (fm.cls_st.value =='6' || fm.cls_st.value =='8')){ alert("매각양도인을 입력하십시오"); return; }		
		if(confirm('등록하시겠습니까?')){					
			fm.action='tax_scd_i_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}
	}

	function set_tax_amt(obj){
		var fm = document.form1;	
		if(obj == fm.sur_rate || obj == fm.tax_rate || obj == fm.tax_amt || obj == fm.edu_tax_amt){//obj == fm.sur_amt || 
//			fm.sur_amt.value = parseDecimal(th_rnd(toInt(parseDigit(fm.car_fs_amt.value))*(parseFloat(parseDigit(fm.sur_rate.value))/100)));
			fm.sur_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value))*(parseFloat(parseDigit(fm.sur_rate.value))/100));			
			if(obj == fm.sur_amt || obj == fm.tax_rate){
				fm.spe_tax_amt.value = parseDecimal(toInt(parseDigit(fm.sur_amt.value))*(parseFloat(parseDigit(fm.tax_rate.value))/100));
				fm.edu_tax_amt.value = parseDecimal(toInt(parseDigit(fm.spe_tax_amt.value))*(30/100));				
			}else if(obj == fm.spe_tax_amt){					
				fm.edu_tax_amt.value = parseDecimal(toInt(parseDigit(fm.spe_tax_amt.value))*(30/100));
			}
		}
		fm.tax_amt.value = parseDecimal(toInt(parseDigit(fm.spe_tax_amt.value))+toInt(parseDigit(fm.edu_tax_amt.value)));		
//		fm.pay_amt.value = fm.tax_amt.value;
	}

	function cng_amt(){
		var fm = document.form1;
		if(fm.cls_man_st.options[fm.cls_man_st.selectedIndex].value == '2' || fm.cls_man_st.options[fm.cls_man_st.selectedIndex].value == '3'){ //면세
			fm.tax_rate.value = '0';
		}else{
			fm.tax_rate.value = fm.h_tax_rate.value;		
		}
		set_tax_amt(fm.tax_rate);
	}

	//디스플레이 타입 - 환입구분
	function cls_display(){
		var fm = document.form1;
		if(fm.tax_st.options[fm.tax_st.selectedIndex].value == '2'){ //매각
			tr_cls_man.style.display	= '';
			if(fm.cont_dt.value != ''){
				fm.tax_come_dt.value = fm.cont_dt.value;							
			}else{
			fm.tax_come_dt.value = fm.cls_dt.value;				
			}
		}else if(fm.tax_st.options[fm.tax_st.selectedIndex].value == '3'){ //용도변경
			tr_cls_man.style.display	= 'none';
			if(fm.cont_dt.value != ''){
				fm.tax_come_dt.value = fm.cont_dt.value;							
			}else{
			fm.tax_come_dt.value = fm.cls_dt.value;				
			}
		}else{
			tr_cls_man.style.display	= 'none';
			fm.tax_come_dt.value = fm.rent_start_dt_add6.value;	
		}
	}	
	
	//디스플레이 타입 - 매각양도인
	function tax_display(){
		var fm = document.form1;
		var cls_man_st = fm.cls_man_st.options[fm.cls_man_st.selectedIndex].value;
		if(cls_man_st == '0' || cls_man_st == '1'){ //일반인,장애인4급이하
			tr_tax.style.display	= '';
			tr_rtn.style.display	= '';
			tr_tax_nm.style.display	= '';
			tr_rtn_nm.style.display	= '';
		}else{
			tr_tax.style.display	= 'none';
			tr_rtn.style.display	= 'none';
			tr_tax_nm.style.display	= 'none';
			tr_rtn_nm.style.display	= 'none';
			fm.sur_rate.value = '0';
			set_tax_amt(fm.sur_rate);
		}
	}
	
	function go_to_list(){
		var fm = document.form1;	
		if(fm.f_list.value == 'pay'){
			fm.action='tax_frame_s.jsp';
		}else{
			fm.action='tax_scd_frame_s.jsp';
		}
		fm.target='d_content';
		fm.submit();	
	}
	
	//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=100, width=620, height=500, scrollbars=yes");		
	}
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='tax_scd_i_a.jsp' target='' method="post">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='est_mon' value='<%=est_mon%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_id' value='<%=car_id%>'>
<input type='hidden' name='h_tax_rate' value='<%=tax_rate%>'>
<input type='hidden' name='f_list' value='<%=f_list%>'>
<input type='hidden' name='rent_mon' value='<%=rent_mon%>'>
<input type='hidden' name='cls_st' value='<%=cls_st%>'>
<input type='hidden' name='rent_start_dt_add6' value='<%=cont.get("TAX_COME_DT")%>'>
<input type='hidden' name='reg_ok' value='<%=reg_ok%>'>
<input type='hidden' name='est_dt2' value='<%=V_EST_DT2%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 재무분석 > 개별소비세 납부현황 > 개별소비세 납부관리 > <span class=style5>개별소비세 등록</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
		<td class=h></td>
	</tr>
    <tr> 
        <td align="right">
	    <%	if((auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) && (reg_ok.equals("") || l_cd.substring(7,8).equals("S"))){%>					  
	    <%		if(tax_reg_count == 0){%>
		<a href='javascript:save();'><img src=../images/center/button_reg.gif border=0 align=absmiddle></a> 
	    <%		}%>
	    <%	}%>
        <a href='javascript:go_to_list();'><img src=../images/center/button_list.gif border=0 align=absmiddle></a>
		</td>
    </tr>
    <tr>
		<td class=line2></td>
	</tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title'>계약번호</td>
                    <td>&nbsp;<%=l_cd%> </td>
                    <td class='title'>상호</td>
                    <td colspan="3">&nbsp;<%=cont.get("FIRM_NM")%> </td>
                    <td class='title'> 사업자등록번호</td>
                    <td align='left'>&nbsp;<%=ssn%></td>
                </tr>
                <tr> 
                    <td class='title'> 신차량번호</td>
                    <td>&nbsp;<%=cont.get("CAR_NO")%></td>
                    <td class='title'> 구차량번호</td>
                    <td>&nbsp;<%=cont.get("FIRST_CAR_NO")%></td>
                    <td class='title'> 차명</td>
                    <td colspan="3" align='left'>&nbsp;<%=mst.getCar_nm()+" "+mst.getCar_name()%></td>
                </tr>
                <tr> 
                    <td width=10% class='title'>소비자가격</td>
                    <td width=15%>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("CAR_C_AMT")))%>원&nbsp;</td>
                    <td width=10% class='title'>구입가격</td>
                    <td width=15%>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("CAR_F_AMT")))%>원&nbsp;</td>
                    <td class='title' width=10%>계약개시일</td>
                    <td width=15%>&nbsp;<%=cont.get("RENT_START_DT")%></td>
                    <td width=10% class='title'>계약종료일</td>
                    <td width=15%>&nbsp;<%=cont.get("RENT_END_DT")%></td>
                </tr>
                <tr> 
                    <td class='title'>출고일자</td>
                    <td>&nbsp;<%=cont.get("DLV_DT")%></td>
                    <td class='title'>최초등록일자</td>
                    <td>&nbsp;<%=cont.get("INIT_REG_DT")%></td>
                    <td class='title'>해지일자</td>
                    <td>&nbsp;<%=cont.get("CLS_DT")%> 
                      <input type='hidden' name='cls_dt' value='<%=cont.get("CLS_DT")%>'>
                    </td>
                    <td class='title'>명의이전일</td>
                    <td>&nbsp;<%=cont.get("MIGR_DT")%><input type='hidden' name='cont_dt' value='<%=cont.get("MIGR_DT")%>'></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>납부 정보</span></td>
    </tr>
    <tr>
		<td class=line2></td>
	</tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>납부구분</td>
                    <td>&nbsp; 
                      <select name="tax_st" onChange="javascript:cls_display()">					  
                        <option value="">선택</option>
                        <option value="1" <%if(tax_st.equals("장기대여")) out.println("selected");%>>장기대여</option>						
						<option value="3" <%if(tax_st.equals("용도변경")) out.println("selected");%>>용도변경</option>
                        <option value="2" <%if(tax_st.equals("매각")) out.println("selected");%>>매각</option>
						<!--<option value="4" <%if(tax_st.equals("폐차")) out.println("selected");%>>폐차</option>-->
                      </select>
                    </td>
                    <td class='title' style='height:36'>납부세율<br>
                      적용기준</td>
                    <td colspan="3">&nbsp; 
                      <select name="tax_apply">
                        <option value="1" >양도가액</option>
                        <option value="2" selected>경과연수별 잔존가치율</option>
                        <option value="3">경과월수별 잔존가치율</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10% style='height:36'>납부사유<br>
                      발생일자</td>
                    <td width=15%>&nbsp; 
                      <input type='text' name='tax_come_dt' value='<%if(!tax_come_dt.equals("")){%><%=tax_come_dt%><%}else{%><%if(cls_st.equals("")){%><%=cont.get("TAX_COME_DT") %><%}else{%><%=cont.get("CONT_DT")%><%}%><%}%>' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'><!-- document.form1.pay_dt.value = this.value;-->
                    </td>
                    <td class='title' width=10%>납부예정일자</td>
                    <td width=15%>&nbsp; 
                      <input type='text' name='est_dt' value='<%=V_EST_DT%>' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'><!-- document.form1.pay_dt.value = this.value;-->
                    </td>
                    <td class='title' width=10%>납부일자</td>
                    <td width=40%>&nbsp; 
                      <input type='text' name='pay_dt' value='' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value); document.form1.pay_amt.value = document.form1.tax_amt.value;'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>매각양도인</td>
                    <td colspan="5">&nbsp; 
                      <select name="cls_man_st" onChange="javascript:tax_display()">
                        <option value="">선택</option>
                        <option value="0">일반인</option>
                        <option value="1">장애4급이하</option>
                        <option value="2">장애3급이상</option>
                        <option value="3">국가유공자</option>
                      </select>
                      &nbsp(* 일반인,장애4급이하 : 과세대상자, 장애3급이상,국가유공자 : 면세대상자) </td>
                </tr>
            </table>
        </td>
    </tr>
    <tR>
        <td></td>
    </tr>
    <tr tr id=tr_tax_nm style="display:''"> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>개별소비세 정보</span></td>
    </tr>
    <tr>
		<td class=line2></td>
	</tr>		
    <tr tr id=tr_tax style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>면세구입가</td>
                    <td width=15%>&nbsp; 
                      <input type='text' name='car_fs_amt' value='<%=Util.parseDecimal(String.valueOf(tax.get("CAR_FS_AMT")))%>' size='11' maxlength='11' class='num'>
                      원</td>
                    <td class=title width=10%>잔존율</td>
                    <td width=15%>&nbsp; 
                      <input type='text' name='sur_rate' value='<%=sur_rate%><%//=t_db.getSurRate(dlv_year, migr_year, cls_st)%><%//=t_db.getSurRate(String.valueOf(cont.get("DLV_DT")), cls_st)%>' size='6' maxlength='6' class='text' onBlur='javascript:set_tax_amt(this);'>
                      %</td>
                    <td width=10% class='title'>잔존가액</td>
                    <td width=15%>&nbsp; 
                      <input type='text' name='sur_amt' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
                      원</td>
                    <td width=10% class='title'>배기량</td>
                    <td width=15%>&nbsp; 
                      <input type='text' name='dpm' value='<%=tax.get("DPM")%>' size='4' maxlength='6' class='whitetext'>
                      CC </td>
                </tr>
                <tr> 
                    <td class='title'>개별소비세율</td>
                    <td>&nbsp; 
                      <input type='text' name='tax_rate' value='<%=tax_rate%>' size='6' maxlength='6' class='num' onBlur='javascript:set_tax_amt(this);'>
                      %</td>
                    <td class='title'>개별소비세액</td>
                    <td>&nbsp; 
                      <input type='text' name='spe_tax_amt' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
                      원</td>
                    <td class='title'>교육세액</td>
                    <td>&nbsp; 
                      <input type='text' name='edu_tax_amt' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
                      원</td>
                    <td class='title'>개별소비세합계</td>
                    <td>&nbsp; 
                      <input type='text' name='tax_amt' maxlength='10' size='10' class='whitenum'>
                      원</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr tr id=tr_rtn_nm style="display:''"> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>환급 정보</span></td>
    </tr>
    <tr>
		<td class=line2></td>
	</tr>		
    <tr tr id=tr_rtn style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=10%>환급일자</td>
                    <td width=15%>&nbsp; 
                      <input type='text' name='rtn_dt' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td class='title' width=10%>환급금액</td>
                    <td width=15%>&nbsp; 
                      <input type='text' name='rtn_amt' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td width=10% class='title'>환급사유</td>
                    <td width=40%>&nbsp; 
                      <input type='text' name='rtn_cau' maxlength='10' size='67' class='text'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%if(!reg_ok.equals("")){%>
    <tr> 
        <td>&nbsp;</td>
    </tr>		
    <tr> 
        <td>개별소비세 과세 대상이 아닙니다.<p>사유 : <%if(tax_reg_count == 0){%><%=cau%><%}else{%>이미 개별소비세 납부된 건입니다.<%}%></td>
    </tr>	
	<%}%>
</table>
</form>

<script language='javascript'>
<!--
	document.form1.sur_amt.value 		= parseDecimal(toInt(parseDigit(document.form1.car_fs_amt.value))*(parseFloat(parseDigit(document.form1.sur_rate.value))/100));
	document.form1.spe_tax_amt.value 	= parseDecimal(toInt(parseDigit(document.form1.sur_amt.value))*(parseFloat(parseDigit(document.form1.tax_rate.value))/100));//th_rnd
	document.form1.edu_tax_amt.value 	= parseDecimal(toInt(parseDigit(document.form1.spe_tax_amt.value))*(30/100));
	document.form1.tax_amt.value 	= parseDecimal(toInt(parseDigit(document.form1.spe_tax_amt.value))+toInt(parseDigit(document.form1.edu_tax_amt.value)));	
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
