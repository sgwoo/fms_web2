<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.cont.*, acar.util.*, acar.con_tax.*, acar.car_mst.*,acar.car_register.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
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
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String gubun7 	= request.getParameter("gubun7")==null?"":request.getParameter("gubun7");
	String est_mon = request.getParameter("est_mon")==null?"":request.getParameter("est_mon");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String f_list 	= request.getParameter("f_list")==null?"":request.getParameter("f_list");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "03", "12");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String car_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String cls_st 	= request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//개별소비세정보
	TaxScdBean bean = bean = t_db.getTaxScdCase("", "", car_id);
	
	if(m_id.equals("")){
		m_id = bean.getRent_mng_id();
		l_cd = bean.getRent_l_cd();
	}
	
	//계약정보
	Hashtable cont = t_db.getAllotByCase(m_id, l_cd);
	//기타정보
	Hashtable tax = t_db.getTaxScdInfo(m_id, l_cd);
	//차량정보
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(car_id);
	
	String ssn = AddUtil.ChangeEnpH(String.valueOf(cont.get("ENP_NO")));		
	
	String car_fs_amt = Integer.toString(bean.getCar_fs_amt());
	if(car_fs_amt.equals("0"))	car_fs_amt = String.valueOf(tax.get("CAR_FS_AMT"));
	
	//자동차회사&차종&자동차명
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
	
	String dlv_year = "";
	String migr_year = "";
	if(!String.valueOf(cont.get("DLV_DT")).equals("")) 	dlv_year = String.valueOf(cont.get("DLV_DT")).substring(0,4);
	
	if(cls_st.equals("6") || cls_st.equals("8")){
//		int dlv_year = t_db.getDlv_year((String)cont.get("DLV_DT"));
		if(String.valueOf(cont.get("MIGR_DT")).length() > 4) migr_year = String.valueOf(cont.get("MIGR_DT")).substring(0,4);
		
		if((AddUtil.parseInt(migr_year)-AddUtil.parseInt(dlv_year)) > 5){
			out.println("출고일자로 부터 5년이 경과된 차량");
		}
	}
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(){
		var fm = document.form1;
		//if(fm.f_list.value != ''){
			if(confirm('수정하시겠습니까?')){					
				fm.action='tax_scd_u_a.jsp';		
				fm.target='i_no';
				fm.submit();
			}
		//}
	}

	function set_tax_amt(obj){
		var fm = document.form1;
		if(obj == fm.sur_rate){
			fm.sur_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value))*(parseFloat(parseDigit(fm.sur_rate.value))/100));		  
			fm.spe_tax_amt.value = parseDecimal(toInt(parseDigit(fm.sur_amt.value))*(parseFloat(parseDigit(fm.tax_rate.value))/100));		  
			fm.edu_tax_amt.value = parseDecimal(toInt(parseDigit(fm.spe_tax_amt.value))*(30/100));
		  fm.tax_amt.value = parseDecimal(toInt(parseDigit(fm.spe_tax_amt.value))+toInt(parseDigit(fm.edu_tax_amt.value)));		
		}else if(obj == fm.sur_amt || obj == fm.tax_rate){
			fm.spe_tax_amt.value = parseDecimal(toInt(parseDigit(fm.sur_amt.value))*(parseFloat(parseDigit(fm.tax_rate.value))/100));		  
			fm.edu_tax_amt.value = parseDecimal(toInt(parseDigit(fm.spe_tax_amt.value))*(30/100));
		  fm.tax_amt.value = parseDecimal(toInt(parseDigit(fm.spe_tax_amt.value))+toInt(parseDigit(fm.edu_tax_amt.value)));		
		}else if(obj == fm.spe_tax_amt){
			fm.edu_tax_amt.value = parseDecimal(toInt(parseDigit(fm.spe_tax_amt.value))*(30/100));
		  fm.tax_amt.value = parseDecimal(toInt(parseDigit(fm.spe_tax_amt.value))+toInt(parseDigit(fm.edu_tax_amt.value)));				  
	  }
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
		}else{
			tr_cls_man.style.display	= 'none';
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
			fm.action = 'tax_frame_s.jsp';
		}else{	
			fm.action='tax_scd_frame_s.jsp';		
		}
		
		if(fm.from_page.value == '/fms2/con_tax/tax_m_frame.jsp'){
			fm.action='/fms2/con_tax/tax_m_frame.jsp';		
		}
		
		fm.target='d_content';
		fm.submit();	
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='tax_scd_u_a.jsp' target='' method="post">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
<input type='hidden' name='gubun6' 	value='<%=gubun6%>'>
<input type='hidden' name='gubun7' 	value='<%=gubun7%>'>
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
<input type='hidden' name='f_list' value='<%=f_list%>'>
<input type='hidden' name='cls_st' value='<%=cls_st%>'>
<input type='hidden' name='h_tax_rate' value='<%=bean.getTax_rate()%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 재무분석 > 개별소비세 납부현황 > 개별소비세 납부관리 > <span class=style5>개별소비세 수정</span></span></td>
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
	    <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		<a href='javascript:save();'><img src=../images/center/button_modify.gif border=0 align=absmiddle></a>
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
                    <td class='title'> 차대번호</td>
                    <td colspan="3" align='left'>&nbsp;<%=cr_bean.getCar_num()%></td>
                </tr>
                <tr> 
                    <td class='title'> 차명</td>
                    <td colspan="3">&nbsp;<%=mst.getCar_nm()+" "+mst.getCar_name()%></td>
                    <td class='title'> 승차정원</td>
                    <td>&nbsp;<%=cr_bean.getTaking_p()%>명</td>
                    <td class='title'> 차종</td>
                    <td>&nbsp;
                        <%=c_db.getNameByIdCode("0041", "", cr_bean.getCar_kd())%>                        		
					</td>
                </tr>				
                <tr> 
                    <td width=10% class='title'>소비자가격</td>
                    <td width=15%>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("CAR_C_AMT")))%>원&nbsp;</td>
                    <td width=10% class='title'>구입가격</td>
                    <td width=15%>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("CAR_F_AMT")))%>원&nbsp;</td>
                    <td width=10% class='title' >계약개시일</td>
                    <td width=15%'>&nbsp;<%=cont.get("RENT_START_DT")%></td>
                    <td width=10% class='title'>만료예정일</td>
                    <td width=15%>&nbsp;<%=cont.get("RENT_END_DT")%></td>
                </tr>
                <tr> 
                    <td class='title'>출고일자</td>
                    <td>&nbsp;<%=cont.get("DLV_DT")%></td>
                    <td class='title'>최초등록일자</td>
                    <td>&nbsp;<%=cont.get("INIT_REG_DT")%></td>
                    <td class='title'>해지일자</td>
                    <td>&nbsp;<%=cont.get("CLS_DT")%></td>
                    <td class='title'>명의이전일</td>
                    <td>&nbsp;<%=cont.get("MIGR_DT")%></td>
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
                    <td width=10% class=title>납부구분</td>
                    <td width=15%>&nbsp; 
                      <select name="tax_st" onChange="javascript:cls_display()">
                        <option value="" <%if(bean.getTax_st().equals(""))%>selected<%%>>선택</option>
                        <option value="1" <%if(bean.getTax_st().equals("1"))%>selected<%%>>장기대여</option>
						<option value="3" <%if(bean.getTax_st().equals("3"))%>selected<%%>>용도변경</option>
                        <option value="2" <%if(bean.getTax_st().equals("2"))%>selected<%%>>매각</option>
						<!--<option value="4" <%if(bean.getTax_st().equals("4"))%>selected<%%>>폐차</option>-->
                      </select>
                    </td>
                    <td width=10% class='title' style='height:36'>납부세율<br>적용기준</td>
                    <td colspan="3">&nbsp; 
                      <select name="tax_apply">
                        <option value="" <%if(bean.getTax_apply().equals(""))%>selected<%%>>선택</option>
                        <option value="1" <%if(bean.getTax_apply().equals("1"))%>selected<%%>>양도가액</option>
                        <option value="2" <%if(bean.getTax_apply().equals("2"))%>selected<%%>>경과연수별 잔존가치율</option>
                        <option value="3" <%if(bean.getTax_apply().equals("3"))%>selected<%%>>경과월수별 잔존가치율</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10% style='height:36'>납부사유<br>발생일자</td>
                    <td width=15%>&nbsp; 
                      <input type='text' name='tax_come_dt' value='<%=bean.getTax_come_dt()%>' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td class='title' width=10%>납부예정일자</td>
                    <td width=15%>&nbsp; 
                      <input type='text' name='est_dt' value='<%=bean.getEst_dt()%>' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'><!-- document.form1.pay_dt.value = this.value;-->
                    </td>
                    <td class='title' width=10%>납부일자</td>
                    <td width=40%>&nbsp; 
                      <input type='text' name='pay_dt' value='<%=bean.getPay_dt()%>' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                </tr>
                <tr id=tr_cls_man style="display:<%if(bean.getTax_st().equals("2")){%>''<%}else{%>none<%}%>"> 
                    <td class='title'>매각양도인</td>
                    <td colspan="5">&nbsp; 
                      <select name="cls_man_st" onchange="javascript:tax_display()">
                        <option value="" <%if(bean.getCls_man_st().equals(""))%>selected<%%>>선택</option>
                        <option value="0" <%if(bean.getCls_man_st().equals("0"))%>selected<%%>>일반인</option>
                        <option value="1" <%if(bean.getCls_man_st().equals("1"))%>selected<%%>>장애4급이하</option>
                        <option value="2" <%if(bean.getCls_man_st().equals("2"))%>selected<%%>>장애3급이상</option>
                        <option value="3" <%if(bean.getCls_man_st().equals("3"))%>selected<%%>>국가유공자</option>
                      </select>
                      (* 일반인,장애4급이하 : 과세대상자, 장애3급이상,국가유공자 : 면세대상자) </td>
                </tr>
            </table>
        </td>
    </tr>
    <tR>
        <td></td>
    </tr>	
    <tr id=tr_tax_nm style="display:''"> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>개별소비세 정보</span></td>
    </tr>
    <tr>
		<td class=line2></td>
	</tr>	
    <tr id=tr_tax style="display:''"> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10% style='height:36'>면세구입가<br>(공급가)</td>
                    <td width=15%>&nbsp; 
                      <input type='text' name='car_fs_amt' value='<%=Util.parseDecimal(car_fs_amt)%>' size='11' maxlength='11' class='num'>
                      원</td>
                    <td class=title  width=10%>잔존율</td>
                    <td width=15%>&nbsp; 
                      <input type='text' name='sur_rate' value='<%=bean.getSur_rate()%>' size='6' maxlength='6' class='text' onBlur='javascript:set_tax_amt(this);'>
                      %</td>
                    <td width=10% class='title'>잔존가액</td>
                    <td width=15%>&nbsp; 
                      <input type='text' name='sur_amt' value='<%=Util.parseDecimal(bean.getSur_amt())%>' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
                      원</td>
                    <td width=10% class='title'>배기량</td>
                    <td width=15%>&nbsp; 
                      <input type='text' name='dpm' value='<%=tax.get("DPM")%>' size='4' maxlength='6' class='whitetext'>
                      CC </td>
                </tr>
                <tr> 
                    <td class='title'>개별소비세율</td>
                    <td>&nbsp; 
                      <input type='text' name='tax_rate' value='<%=bean.getTax_rate()%>' size='6' maxlength='6' class='text' onBlur='javascript:set_tax_amt(this);'>
                      %</td>
                    <td class='title'>개별소비세액</td>
                    <td >&nbsp; 
                      <input type='text' name='spe_tax_amt' value='<%=Util.parseDecimal(bean.getSpe_tax_amt())%>' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
                      원</td>
                    <td  class='title'>교육세액</td>
                    <td >&nbsp; 
                      <input type='text' name='edu_tax_amt' value='<%=Util.parseDecimal(bean.getEdu_tax_amt())%>' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
                      원</td>
                    <td  class='title'>개별소비세합계</td>
                    <td>&nbsp; 
                      <input type='text' name='tax_amt' maxlength='10' size='10' class='whitenum' value="<%=Util.parseDecimal(bean.getPay_amt())%>">
                      원</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr id=tr_rtn_nm style="display:''"> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>환급 정보</span></td>
    </tr>
    <tr>
		<td class=line2></td>
	</tr>		
    <tr id=tr_rtn style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width="85">환급일자</td>
                    <td width="115">&nbsp; 
                      <input type='text' name='rtn_dt' value='<%=bean.getRtn_dt()%>' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td class='title' width="85">환급금액</td>
                    <td width="115">&nbsp; 
                      <input type='text' name='rtn_amt' value='<%=Util.parseDecimal(bean.getRtn_amt())%>' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td width='85' class='title'>환급사유</td>
                    <td width="315">&nbsp; 
                      <input type='text' name='rtn_cau' maxlength='10' size='67' class='text' value="<%=bean.getRtn_cau()%>">
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
</table>
</form>

&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_jjy.gif align=absmiddle><span class=style7> :	
  <%=t_db.getSurRate(dlv_year, migr_year, cls_st)%>%
  <%=t_db.getSurRate2(String.valueOf(cont.get("DLV_DT")), String.valueOf(cont.get("MIGR_DT")), cls_st)%>%  
  <%if(AddUtil.parseInt(String.valueOf(cont.get("DPM"))) > 500){ %>
&nbsp;&nbsp;<img src=../images/center/arrow_tssy.gif align=absmiddle> :	  
  <%=t_db.getTaxRate("특소세", (String)tax.get("DPM"), (String)cont.get("DLV_DT"))%>%
  <%} %>
  </span>
  

<script language='javascript'>
<!--
	document.form1.tax_amt.value = parseDecimal(toInt(parseDigit(document.form1.spe_tax_amt.value))+toInt(parseDigit(document.form1.edu_tax_amt.value)));

	var fm = document.form1;

	//바로가기
	var s_fm = parent.top_menu.document.form1;
	s_fm.m_id.value = fm.m_id.value;
	s_fm.l_cd.value = fm.l_cd.value;	
	s_fm.c_id.value = fm.car_id.value;
	s_fm.auth_rw.value = fm.auth_rw.value;
	s_fm.user_id.value = fm.user_id.value;
	s_fm.br_id.value = fm.br_id.value;		
	s_fm.client_id.value = "";				
	s_fm.accid_id.value = "";
	s_fm.serv_id.value = "";
	s_fm.seq_no.value = "";
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
