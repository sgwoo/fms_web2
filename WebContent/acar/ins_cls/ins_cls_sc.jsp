<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_register.*, acar.insur.*"%>
<jsp:useBean id="car" 	class="acar.car_register.CarRegBean" 	scope="page"/>
<jsp:useBean id="ins" 	class="acar.insur.InsurBean" 			scope="page"/>
<jsp:useBean id="sBean" class="acar.offls_sui.SuiBean" scope="page"/>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");//자동차관리번호
	String y_days = "365";
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "06", "02");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase car_db = CarRegDatabase.getInstance();
	InsDatabase ins_db = InsDatabase.getInstance();
	
	//차량정보
	car = car_db.getCarRegBean(c_id);
	
	//보험정보
	ins = ins_db.getInsCase(c_id, ins_st);
	
	//보험기간동안 일수 구하기
	y_days = ins_db.getTotInsDays(c_id, ins_st);
%> 
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
	function aim_display(){
	return;
		var fm = document.form1;
		var car_use = fm.car_use.value;
		var ins_kd = fm.ins_kd.value;
		td_aim1.style.display = 'none';
		td_aim2.style.display = 'none';
		td_aim3.style.display = 'none';
		td_aim4.style.display = 'none';
		td_aim5.style.display = 'none';
		if(ins_kd == '2'){//책임보험
			td_aim3.style.display = '';
		}else{//종합보험
			if(car_use == '1'){//영업용(렌트)
				if(fm.exp_st[0].checked == true){	
					td_aim1.style.display = '';	
					td_aim2.style.display = ''; 	
				}else if(fm.exp_st[1].checked == true){	
					td_aim4.style.display = '';	
					td_aim5.style.display = ''; 	
				}
					td_aim3.style.display = '';
					td_aim6.style.display = '';
			}else{//업무용(리스)
				if(fm.exp_st[0].checked == true){	
					td_aim1.style.display = '';	
					td_aim2.style.display = ''; 	
				}else if(fm.exp_st[1].checked == true){	
					td_aim4.style.display = '';	
					td_aim5.style.display = ''; 	
					td_aim3.style.display = ''; 	
				}
					td_aim6.style.display = '';							
			}
		}
	}
	
	//해지사유발생일자 입력시 셋팅
	function set_use(){
		var fm = document.form1;
		var t_use_amt = 0;		
		var t_ins_amt = 0;
		var st;
		var et;
		var days;
		var daysRound;
		var ins_kd = fm.ins_kd.value;
		
		if(fm.cls_st[0].checked == true){
			fm.ins_end_dt.value = fm.exp_dt.value;				
			
			for(i=0; i<7; i++){
				st = new Date(replaceString("-","/",fm.ins_start_dt[i].value));//시작일
				et = new Date(replaceString("-","/",fm.ins_end_dt.value));//종료일
				days = (et - st) / 1000 / 60 / 60 / 24; //1일=24시간*60분*60초*1000milliseconds
				daysRound = Math.floor(days);//+1:시작일 포함
				fm.use_day[i].value = daysRound;
				fm.use_amt[i].value = parseDecimal( th_round(toInt(parseDigit(fm.ins_amt[i].value)) /<%=y_days%> * daysRound) );
				t_use_amt = t_use_amt + toInt(parseDigit(fm.use_amt[i].value));
				t_ins_amt = t_ins_amt + toInt(parseDigit(fm.ins_amt[i].value));
			}
			fm.use_amt[7].value = parseDecimal(t_use_amt);
			fm.ins_amt[7].value = parseDecimal(t_ins_amt);
			fm.tot_use_amt.value = parseDecimal(t_use_amt);
			fm.tot_ins_amt.value = parseDecimal(t_ins_amt);
			
			fm.rtn_est_amt.value = parseDecimal( toInt(parseDigit(fm.tot_ins_amt.value))-toInt(parseDigit(fm.tot_use_amt.value))-toInt(parseDigit(fm.nopay_amt.value)) );
			if(toInt(parseDigit(fm.rtn_amt.value)) > 0){
				fm.dif_amt.value = parseDecimal( toInt(parseDigit(fm.rtn_est_amt.value)) - toInt(parseDigit(fm.rtn_amt.value)) );						
			}
		}
	}
		
	//해지 보험료 합계 셋팅
	function set_tot_use(){
		var fm = document.form1;
		var ins_kd = fm.ins_kd.value;
		var t_use_amt = 0;
		if(fm.cls_st[0].checked == true){
		
			for(i=0; i<7; i++){
				t_use_amt = t_use_amt + toInt(parseDigit(fm.use_amt[i].value));
			}
			fm.use_amt[7].value = parseDecimal(t_use_amt);
			fm.tot_use_amt.value = parseDecimal(t_use_amt);
			
			fm.rtn_est_amt.value = parseDecimal( toInt(parseDigit(fm.tot_ins_amt.value))-toInt(parseDigit(fm.tot_use_amt.value))-toInt(parseDigit(fm.nopay_amt.value)) );
			if(toInt(parseDigit(fm.rtn_amt.value)) > 0){
				fm.dif_amt.value = parseDecimal( toInt(parseDigit(fm.rtn_est_amt.value)) - toInt(parseDigit(fm.rtn_amt.value)) );				
			}
		}
	}
	
	//책임보험유지시 셋팅	
	function set_use_amt(idx){
		var fm = document.form1;
		if(fm.cls_st[0].checked == true){
			if(fm.exp_yn[idx].options[fm.exp_yn[idx].selectedIndex].value == 'N'){			
				fm.use_amt[idx].value = parseDecimal( th_rnd(toInt(parseDigit(fm.ins_amt[idx].value)) /<%=y_days%> * toInt(fm.use_day[idx].value)) );		
			}else{
				fm.use_amt[idx].value = 0;				
			}
		}
	}
	
	//환급금 입력시 차액 계산
	function set_dif(){
		var fm = document.form1;
		if(toInt(parseDigit(fm.rtn_amt.value)) > 0){		
			fm.dif_amt.value = parseDecimal( toInt(parseDigit(fm.rtn_est_amt.value)) - toInt(parseDigit(fm.rtn_amt.value)) );		
		}
	}
	
	//환급예정금액과 환급금과 동일시 체크하면 값 넘기기
	function Rtn_chk(){
		var fm = document.form1;
		if(fm.rtn_chk.checked == true){
			fm.rtn_amt.value = fm.rtn_est_amt.value;					
			fm.dif_amt.value = "0";			
		}else{
			fm.dif_amt.value = parseDecimal( toInt(parseDigit(fm.rtn_est_amt.value)) - toInt(parseDigit(fm.rtn_amt.value)) );
		}
	}
	
	function save(){
		var fm = document.form1;
		var len=fm.elements.length;
		var exp_st=0;
		var exp_aim=0;
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "exp_st" && ck.checked == true)	exp_st++;
			if(ck.name == "exp_aim" && ck.checked == true)	exp_aim++;			
		}	
		if(exp_st == 0){									alert('용도변경 내용을 선택하십시오.');		return;	}
		if(exp_aim == 0){ 									alert('용도변경 목적을 선택하십시오.'); 	return; }		
		if(fm.c_id.value == '' || fm.ins_st.value == ''){ 	alert('차량을 선택하십시오.'); 				return; }
		if(fm.exp_dt.value == ''){ 							alert('해지사유발생일자를 입력하십시오.'); 	return; }
		if(fm.req_dt.value == ''){ 							alert('청구/승계일자를 입력하십시오.');		return; }		
		
		if(fm.cls_st[0].checked == true){
			if(fm.rtn_est_amt.value == ''){ 					alert('환급예정금액을 입력하십시오.'); 		return; }			
		
			if(toInt(parseDigit(fm.rtn_amt.value)) == 0 || fm.rtn_amt.value == ''){		
				fm.scd_ins_amt.value = fm.rtn_est_amt.value;
			}else{
				fm.scd_ins_amt.value = fm.rtn_amt.value;
			}
		}
		
		if(!confirm('등록하시겠습니까?')){	return;	}
		//fm.target = 'i_no';
		fm.action = 'ins_cls_a.jsp';
		fm.submit();
	}
</script>
</head>

<body>
<form name='form1' method='post'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="ins_st" value='<%=ins_st%>'>
<input type='hidden' name="car_use" value='<%=ins.getCar_use()%>'>
<input type='hidden' name="ins_kd" value='<%=ins.getIns_kd()%>'>
<input type='hidden' name="scd_ins_amt" value=''>
<input type='hidden' name="car_no" value='<%=car.getCar_no()%>'>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>차량번호</td>
                    <td width=13%>&nbsp;<%=car.getCar_no()%><a href=# title=<%=c_id+" "+ins_st%>>&nbsp;<font color="#999999">(<%=ins_st%>)</font></a></td>
                    <td class=title width=10%>차명</td>
                    <td width=20%>&nbsp;<%=car.getCar_nm()%></td>
                    <td class=title width=10%>최초등록일</td>
                    <td width=13%>&nbsp;<%=AddUtil.ChangeDate2(car.getInit_reg_dt())%></td>
                    <td class=title width=10%>차대번호</td>
                    <td width=14%>&nbsp;<%=car.getCar_num()%></td>
                </tr>
                <tr> 
                    <td class=title>보험사</td>
                    <td>&nbsp;<%=c_db.getNameById(ins.getIns_com_id(), "INS_COM")%></td>
                    <td class=title>보험기간</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(ins.getIns_start_dt())%>~<%=AddUtil.ChangeDate2(ins.getIns_exp_dt())%></td>
                    <td class=title>보험종류</td>
                    <td> 
                      <%if(ins.getCar_use().equals("1")) {%>
                      &nbsp;영업용 
                      <%}else{%>
                      &nbsp;업무용 
                      <%}%>
                    </td>
                    <td class=title>담보구분</td>
                    <td> 
                      <%if(ins.getIns_kd().equals("1")) {%>
                      &nbsp;전담보 
                      <%}else{%>
                      &nbsp;책임보험 
                      <%}%>
                    </td>
                </tr>
                <tr> 
                    <td class=title>증권번호</td>
                    <td colspan="7">&nbsp;<%=ins.getIns_con_no()%></td>
                </tr>		  
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
    <%	sBean = olsD.getSui(c_id);
		if(!sBean.getMigr_dt().equals("")){%>	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>오프리스</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width=10% style='height:36'>변경전<br>차량번호</td>
                    <td width=13%>&nbsp;<%=car.getFirst_car_no()%></td>
                    <td class=title width=10%>계약자</td>
                    <td width=20%>&nbsp;<%=sBean.getSui_nm()%></td>
                    <td class=title width=10%>계약일자</td>
                    <td width=13%>&nbsp;<%=AddUtil.ChangeDate2(sBean.getCont_dt())%></td>
                    <td class=title width=10%>명의이전일</td>
                    <td width=14%>&nbsp;<%=AddUtil.ChangeDate2(sBean.getMigr_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
    <%	}//else{%>
    <%		//용도변경 이력
			Vector cngs = ins_db.getCarNoCng(c_id);
			int cng_size = cngs.size();
			if(cng_size > 0){%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>용도변경</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
              <%     		for(int i = 0 ; i < cng_size ; i++){
    					Hashtable cng = (Hashtable)cngs.elementAt(i);
    					String cha_cau = String.valueOf(cng.get("CHA_CAU"));%>
                <tr> 
                    <td class=title width=10%>변경일자</td>
                    <td width=13%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(cng.get("CHA_DT")))%></td>
                    <td class=title width=10%>변경사유</td>
                    <td width=20%> 
                      <%if(cha_cau.equals("1")){%>
                      &nbsp;사용본거지 변경 
                      <%}else if(cha_cau.equals("2")){%>
                      &nbsp;용도변경 
                      <%}else if(cha_cau.equals("3")){%>
                      &nbsp;기타 
                      <%}else if(cha_cau.equals("4")){%>
                      &nbsp;없음 
                      <%}else if(cha_cau.equals("5")){%>
                      &nbsp;신규등록 
                      <%}%>
                    </td>
                    <td class=title width=10%>변경내용</td>
                    <td width=37%>&nbsp;<%=cng.get("CHA_CAU_SUB")%> </td>
                </tr>
              <%			}%>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>		
    <%		}
		//}
	%>
	<%	//보험스케줄
			Vector ins_scd = ins_db.getInsScds(c_id, ins_st, "0");
			int ins_scd_size = ins_scd.size();	
			if(ins_scd_size > 0){%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>미납보험료</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" width="100%">
                <tr> 
                    <td class=title width=10%>회차</td>
                    <td class=title width=30%>구분</td>
                    <td class=title width=30%>납부예정일</td>
                    <td class=title width=30%>납부금액</td>
                </tr>
              <%	for(int i = 0 ; i < ins_scd_size ; i++){
    					InsurScdBean scd = (InsurScdBean)ins_scd.elementAt(i);%>
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td> 
                      <select name='ins_tm2' disabled>
                        <option value='0' <%if(scd.getIns_tm2().equals("0")){%>selected<%}%>>당초납입보험료</option>
                        <option value='1' <%if(scd.getIns_tm2().equals("1")){%>selected<%}%>>추가보험료</option>
                        <option value='2' <%if(scd.getIns_tm2().equals("2")){%>selected<%}%>>해지보험료</option>
                      </select>
                    </td>
                    <td><%=scd.getIns_est_dt()%></td>
                    <td><%=Util.parseDecimal(scd.getPay_amt())%>원</td>
                </tr>
              <%
    			  }%>
            </table>
        </td>
    </tr>				
    <%	}%>				
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험해지</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title rowspan="2" width=7%>용도<br>
                      변경</td>
                    <td class=title width=10%><font color="#FF0000">* </font>내용</td>
                    <td colspan="3">
        			<%if(sBean.getMigr_dt().equals("")){%> 			 
                      <%if(ins.getIns_kd().equals("") || ins.getIns_kd().equals("1")){%>
                      <%if(ins.getCar_use().equals("1")){%>
                      <input type="radio" name="exp_st" value="1" onclick="javascript:aim_display()">
                      영업용(R)-&gt;업무용(L) 
                      <%}else if(ins.getCar_use().equals("2")){%>
                      <input type="radio" name="exp_st" value="2" onclick="javascript:aim_display()">
                      업무용(L)-&gt;영업용(R) 
                      <%}%>
                      <input type="radio" name="exp_st" value="3" onclick="javascript:aim_display()">
                      없음 
                      <%}else{%>
                      <input type="radio" name="exp_st" value="3" onclick="javascript:aim_display()">
                      없음 
                      <%}%>
        			<%}else{%>	
                      <input type="radio" name="exp_st" value="3" checked>
                      없음 
        			<%}%>
                     </td>
                </tr>
                <tr> 
                    <td class=title><font color="#FF0000">* </font>목적</td>
                    <td colspan="3">
        			<%if(sBean.getMigr_dt().equals("")){%> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td id="td_aim1" width="70" style="display:''"> 
                                <input type="radio" name="exp_aim" value="1">
                                재리스</td>
                              <td id="td_aim2" width="70" style="display:''"> 
                                <input type="radio" name="exp_aim" value="2">
                                Self</td>
                              <td id="td_aim3" width="70" style="display:''"> 
                                <input type="radio" name="exp_aim" value="3">
                                매각</td>
                              <td id="td_aim4" width="70" style="display:''"> 
                                <input type="radio" name="exp_aim" value="4">
                                말소</td>
                              <td id="td_aim5" width="70" style="display:''"> 
                                <input type="radio" name="exp_aim" value="5">
                                폐차</td>
                              <td id="td_aim6" width="70" style="display:''"> 
                                <input type="radio" name="exp_aim" value="9">
                                기타</td>
                              <td>&nbsp;</td>
                            </tr>
                        </table>
    			<%}else{%>
    			    <input type="radio" name="exp_aim" value="3" checked>
                        매각
    			<%}%>
                    </td>
                </tr>
                <tr> 
                    <td class=title colspan="2"><font color="#FF0000">* </font>해지구분</td>
                    <td colspan="3"> 
                      <input type="radio" name="cls_st" value="1" onClick="javascript:tr_cls1.style.display='';tr_cls2.style.display='';tr_cls3.style.display='';">보험해지
        			  <input type="radio" name="cls_st" value="2" onClick="javascript:tr_cls1.style.display='none'; tr_cls2.style.display='none'; tr_cls3.style.display='none';">보험승계			  
                    </td>
                </tr>		  
                <tr> 
                    <td class=title colspan="2"><font color="#FF0000">* </font>해지사유발생일자</td>
                    <td width=36%> 
                      &nbsp;<input type='text' size='11' name='exp_dt' class='text' value='' onBlur='javascript:this.value=ChangeDate(this.value); set_use();'>
                    </td>
                    <td class=title width=10%><font color="#FF0000">* </font>청구/승계일자</td>
                    <td width=37%> 
                      <input type='text' size='11' name='req_dt' class='text' value='' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    <tr id="tr_cls1" style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title colspan="2">담보</td>
                    <td class=title>보상한도</td>
                    <td class=title>보험료</td>
                    <td class=title>계약개시일</td>
                    <td class=title>계약종료일</td>
                    <td class=title>경과일수</td>
                    <td class=title>구분</td>
                    <td class=title>경과보험료</td>
                </tr>
                <tr> 
                    <td class=title width=7%>책임보험</td>
                    <td class=title width=10%>대인배상Ⅰ</td>
                    <td width=14%>&nbsp;</td>
                    <td align="center" width=12%> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getRins_pcp_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_use();'>
                      원</td>
                    <td align="center" width=10%> 
                      <input type='text' size='12' name='ins_start_dt' value='<%=AddUtil.ChangeDate2(ins.getIns_start_dt())%>' class='whitetext' onBlur='javascript:this.value=ChangeDate(this.value); set_use();'>
                    </td>
                    <td align="center" rowspan="7" width=10%> 
                      <input type='text' size='12' name='ins_end_dt' value='' class='whitetext' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td align="center" width=12%> 
                      <input type='text' size='3' name='use_day' value='' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      일</td>
                    <td align="center" width=12%> 
                      <select name="exp_yn" <%if(ins.getCar_use().equals("2") && ins.getIns_kd().equals("1")){%>onchange="javascript:set_use_amt(0);"<%}else{%>disabled<%}%>>
                        <option value="N" selected>해지</option>
                        <option value="Y">유지</option>
                      </select>
                    </td>
                    <td align="center" width=13%> 
                      <input type='text' size='10' name='use_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title rowspan="4">임의보험</td>
                    <td class=title>대인배상Ⅱ</td>
                    <td> 
                      <%if(ins.getVins_pcp_kd().equals("1")){%>
                      &nbsp;무한 
                      <%}%>
                      <%if(ins.getVins_pcp_kd().equals("2")){%>
                      &nbsp;유한 
                      <%}%>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getVins_pcp_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_use();'>
                      원</td>
                    <td align="center"> 
                      <input type='text' size='12' name='ins_start_dt' class='whitetext' value='<%=AddUtil.ChangeDate2(ins_db.getChInsDt(c_id, ins_st, ins.getIns_start_dt(), "10"))%>' onBlur='javascript:this.value=ChangeDate(this.value); set_use();'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='3' name='use_day' value='' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      일</td>
                    <td align="center"> 
                      <select name="exp_yn" disabled>
                        <option value="N">해지</option>
                        <option value="Y">유지</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>대물배상&nbsp;&nbsp;</td>
                    <td> 
                      <%if(ins.getVins_gcp_kd().equals("6")){%>
                      &nbsp;5억원 
                      <%}%>
					  <%if(ins.getVins_gcp_kd().equals("8")){%>
                      &nbsp;3억원 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("7")){%>
                      &nbsp;2억원 
                      <%}%>					  
                      <%if(ins.getVins_gcp_kd().equals("3")){%>
                      &nbsp;1억원 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("4")){%>
                      &nbsp;5000만원 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("1")){%>
                      &nbsp;3000만원 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("2")){%>
                      &nbsp;1500만원 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("5")){%>
                      &nbsp;1000만원 
                      <%}%>			  
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getVins_gcp_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_use();'>
                      원</td>
                    <td align="center"> 
                      <input type='text' size='12' name='ins_start_dt' class='whitetext' value='<%=AddUtil.ChangeDate2(ins_db.getChInsDt(c_id, ins_st, ins.getIns_start_dt(), "(7,1)"))%>' onBlur='javascript:this.value=ChangeDate(this.value); set_use();'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='3' name='use_day' value='' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      일</td>
                    <td align="center"> 
                      <select name="exp_yn" disabled>
                        <option value="N" selected>해지</option>
                        <option value="Y">유지</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>자기신체사고</td>
                    <td> 
                      <%if(ins.getVins_bacdt_kd().equals("1")){%>
                      &nbsp;3억원 
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("2")){%>
                      &nbsp;1억5천만원 
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("6")){%>
                      &nbsp;1억원 
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("5")){%>
                      &nbsp;5000만원 
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("3")){%>
                      &nbsp;3000만원 
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("4")){%>
                      &nbsp;1500만원 
                      <%}%>
                      / 
                      <%if(ins.getVins_bacdt_kc2().equals("1")){%>
                      3억원 
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("2")){%>
                      1억5천만원 
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("6")){%>
                      1억원 
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("5")){%>
                      5000만원 
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("3")){%>
                      3000만원 
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("4")){%>
                      1500만원 
                      <%}%>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getVins_bacdt_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_use();'>
                      원</td>
                    <td align="center"> 
                      <input type='text' size='12' name='ins_start_dt' class='whitetext' value='<%=AddUtil.ChangeDate2(ins_db.getChInsDt(c_id, ins_st, ins.getIns_start_dt(), "(7,2)"))%>' onBlur='javascript:this.value=ChangeDate(this.value); set_use();'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='3' name='use_day' value='' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      일</td>
                    <td align="center"> 
                      <select name="exp_yn" disabled>
                        <option value="N" selected>해지</option>
                        <option value="Y">유지</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>자기차량손해</td>
                    <td>&nbsp;<%=ins.getVins_cacdt_car_amt()%>원/<%=ins.getVins_cacdt_me_amt()%>원	
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getVins_cacdt_cm_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_use();'>
                      원</td>
                    <td align="center"> 
                      <input type='text' size='12' name='ins_start_dt' class='whitetext' value='<%=AddUtil.ChangeDate2(ins_db.getChInsDt(c_id, ins_st, ins.getIns_start_dt(), "9"))%>' onBlur='javascript:this.value=ChangeDate(this.value); set_use();'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='3' name='use_day' value='' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      일</td>
                    <td align="center"> 
                      <select name="exp_yn" disabled>
                        <option value="N" selected>해지</option>
                        <option value="Y">유지</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title rowspan="2">특약</td>
                    <td class=title>무보험차상해</td>
                    <td> </td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getVins_canoisr_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_use();'>
                      원</td>
                    <td align="center"> 
                      <input type='text' size='12' name='ins_start_dt' class='whitetext' value='<%=AddUtil.ChangeDate2(ins_db.getChInsDt(c_id, ins_st, ins.getIns_start_dt(), "3"))%>' onBlur='javascript:this.value=ChangeDate(this.value); set_use();'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='3' name='use_day' value='' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      일</td>
                    <td align="center"> 
                      <select name="exp_yn" disabled>
                        <option value="N" selected>해지</option>
                        <option value="Y">유지</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>긴급출동</td>
                    <td>&nbsp;<%=ins.getVins_spe()%></td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getVins_spe_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_use();'>
                      원</td>
                    <td align="center"> 
                      <input type='text' size='12' name='ins_start_dt' class='whitetext' value='<%=AddUtil.ChangeDate2(ins_db.getChInsDt(c_id, ins_st, ins.getIns_start_dt(), "6"))%>' onBlur='javascript:this.value=ChangeDate(this.value); set_use();'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='3' name='use_day' value='' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      일</td>
                    <td align="center"> 
                      <select name="exp_yn" disabled>
                        <option value="N" selected>해지</option>
                        <option value="Y">유지</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use()'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title rowspan="5" colspan="2">합계</td>
                    <td>&nbsp; </td>
                    <td align="center"> 
                      <input type='text' size='10' name='ins_amt' value='<%=Util.parseDecimal(ins.getRins_pcp_amt()+ins.getVins_pcp_amt()+ins.getVins_gcp_amt()+ins.getVins_bacdt_amt()+ins.getVins_cacdt_cm_amt()+ins.getVins_canoisr_amt()+ins.getVins_spe_amt())%>' class='whitenum' readonly>
                      원</td>
                    <td align="center" colspan="4">&nbsp;</td>
                    <td align="center"> 
                      <input type='text' size='10' name='use_amt' value='' class='num' readonly>
                      원</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    <tr id="tr_cls2" style="display:''"> 
        <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td class=line> 
                        <table border="0" cellspacing="1" width=100%>
                            <tr> 
                                <td class=title width=17%>총보험료</td>
                                <td width=14%> 
                                <input type='text' name='tot_ins_amt' value='<%=Util.parseDecimal(ins.getRins_pcp_amt()+ins.getVins_pcp_amt()+ins.getVins_gcp_amt()+ins.getVins_bacdt_amt()+ins.getVins_cacdt_cm_amt()+ins.getVins_canoisr_amt()+ins.getVins_spe_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use();'>
                                원</td>
                                <td class=title width=14%>총경과보험료</td>
                                <td width=18%> 
                                <input type='text' size='10' name='tot_use_amt' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use();'>
                                원</td>
                                <td class=title width=14%>차회보험료</td>
                                <td width=23%> 
                                <input type='text' name='nopay_amt' value='<%=Util.parseDecimal(ins_db.getNopayAmt(c_id, ins_st))%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_use();'>
                                원 (미납부보험료)</td>
                            </tr>
                            <tr> 
                                <td class=title>환급예정금액</td>
                                <td colspan="5"> 
                                <input type='text' size='10' name='rtn_est_amt' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
                                원 <font color="#999999">(=총보험료-총경과보험료-차회보험료)</font>&nbsp;&nbsp;
                                환급금과 일치
                                <input type="checkbox" name="rtn_chk" value="Y" onClick="javascript:Rtn_chk();">
                              </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
    <tr id="tr_cls3" style="display:''"> 
        <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험환급</span></td>
                </tr>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class=line> 
                        <table border="0" cellspacing="1" width=100%>
                            <tr> 
                              <td class=title width=17%>환급금</td>
                              <td width=14%> 
                                <input type='text' name='rtn_amt' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_dif();'>
                                원</td>
                              <td class=title width=14%>입금일자</td>
                              <td width=18%> 
                                <input type='text' size='11' name='rtn_dt' class='text' value='' onBlur='javascript:this.value=ChangeDate(this.value)'>
                              </td>
                              <td class=title width=14%>차액</td>
                              <td width=23%> 
                                <input type='text' name='dif_amt' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                                원</td>
                            </tr>
                            <tr> 
                              <td class=title>사유</td>
                              <td colspan="5"> 
                                <input type="text" name="dif_cau" size="120" value="" class="text" style='IME-MODE: active'>
                              </td>
                            </tr>
                            <tr> 
                              <td class=title>자동전표 계정과목</td>
                              <td colspan="5"> 
                     			 <input type="radio" name="acct_code" value="10300" <%if(ins.getIns_com_id().equals("0007")){%>checked<%}%>>보통예금
        			 			 <input type="radio" name="acct_code" value="12000" <%if(ins.getIns_com_id().equals("0008")||ins.getIns_com_id().equals("0038")){%>checked<%}%>>미수금
                              </td>
                            </tr>							
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"> 
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href='javascript:save()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a> 
        <%}%>
      </td>
    </tr>
</table>
  <iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</form>
<script language='javascript'>
<!--
	set_tot_use();
//-->
</script>
</body>
</html>
