<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.* "%>
<%@ page import="acar.accid.*,  acar.user_mng.* , acar.car_service.*, acar.insur.* "%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<jsp:useBean id="s_bean2" class="acar.car_service.ServiceBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String mode = request.getParameter("mode")==null?"1":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "02");
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//사고조회
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	
	String accid_dt = a_bean.getAccid_dt();
	String accid_dt_h = "";
	String accid_dt_m = "";
	if(!accid_dt.equals("")){
		accid_dt = a_bean.getAccid_dt().substring(0,8);
		accid_dt_h = a_bean.getAccid_dt().substring(8,10);
		accid_dt_m = a_bean.getAccid_dt().substring(10,12);
	}
	
	
	//정비/점검(면책금)
	ServiceBean s_r [] = as_db.getServiceList(c_id, accid_id);
	ServiceBean s_bean = as_db.getService(c_id, accid_id);
	
	//보험정보
	String ins_st = ai_db.getInsStNow(c_id, a_bean.getAccid_dt());
	InsurBean ins = ai_db.getIns(c_id, ins_st);
	String ins_com_nm = ai_db.getInsComNm(c_id, ins_st);
		
	if(a_bean.getOur_ins().equals("")){
		a_bean.setOur_ins(ins_com_nm);
	}
			
	//보험청구내역(휴차/대차료)
//	MyAccidBean ma_bean = as_db.getMyAccid(c_id, accid_id);	
	
	int tot_sv_amt = 0;
	int tot_sv_req_amt = 0;
	int tot_sv_pay_amt = 0;
	int tot_accid_amt = 0;
	
	String no_dft_yn = "";
	
	for(int i=0; i<s_r.length; i++){
		s_bean2 = s_r[i];
		no_dft_yn =  s_bean2.getNo_dft_yn();
		
		if(!s_bean2.getNo_dft_yn().equals("Y") && !s_bean2.getServ_st().equals("7")){
			tot_sv_amt 		+= s_bean2.getTot_amt();
		}
		
		tot_accid_amt 	+= s_bean2.getTot_amt();
		tot_sv_req_amt 	+= s_bean2.getCust_amt();
		tot_sv_pay_amt 	+= s_bean2.getExt_amt();
		if(s_bean2.getDly_amt()>0){
			tot_sv_req_amt  += s_bean2.getDly_amt();
			tot_sv_pay_amt 	+= s_bean2.getDly_amt();
		}
		if(s_bean2.getCls_amt()>0){
			tot_sv_req_amt  += s_bean2.getCls_amt();
			tot_sv_pay_amt 	+= s_bean2.getCls_amt();
		}
	}	
		
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCaseAccid(c_id, accid_id);
	
	//대차차량정보
	Hashtable reserv = rs_db.getCarInfo(rc_bean.getCar_mng_id());
	
	//보험청구내역리스트
	MyAccidBean my_r [] = as_db.getMyAccidList(c_id, accid_id);
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정하기
	function save(){	
		var fm = document.form1;	
		dt_chk();
		if(fm.accid_id.value == ''){ alert("상단을 먼저 등록하십시오."); return; }
						
		if ( fm.pre_cls.checked == true) {
			//해지 사전처리 가능 면책금 확인건 - alert
			if(fm.chk_cnt.value == '1'){ alert("사고정비는 있는데 면책금이 청구되지 않은 상태입니다."); return; }		
			if(fm.chk_cnt.value == '2'){ alert("대차가 있는대 휴/대차료가 청구되지 않은 상태입니다."); return; }		
			
			<%	if(!a_bean.getAccid_st().equals("1") )  { %>		 //피해가 아니면 	
			<%	if ( no_dft_yn =="N" && tot_sv_req_amt < 1 ) { %>
					alert("면책금이 청구되지 않은 상태입니다. 확인하시후 진행하세요!!!");
					return;	
			<%	} %>
					
		<% 	}	%>	
		
		}
		
		if(!confirm('수정하시겠습니까?')){	return;	}
		if(fm.accid_dt_h.value == ''){ fm.accid_dt_h.value='00'; }		
		if(fm.accid_dt_m.value == ''){ fm.accid_dt_m.value='00'; }				
		fm.h_accid_dt.value = fm.accid_dt.value+fm.accid_dt_h.value+fm.accid_dt_m.value;
		fm.target = "i_no";
		fm.submit();
	}
	
	//보유차 기간과 사고일시 비교
	function dt_chk(){
		var fm = document.form1;	
		if(fm.car_st.value == '2' && fm.sub_rent_gu.value != '99'){
			var st_dt = replaceString("-","",fm.sub_rent_st.value);
			var et_dt = replaceString("-","",fm.sub_rent_et.value);
			var dt = replaceString("-","",fm.accid_dt.value);
			if(st_dt > dt){ alert('보유차 계약기간과 사고일자가 맞지 않습니다.'); return; 	}
			if(et_dt < dt){ alert('보유차 계약기간과 사고일자가 맞지 않습니다.'); return;	}
		}
	}		
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="accid_u_a.jsp" name="form1">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
    <input type='hidden' name='m_id' value='<%=m_id%>'>
    <input type='hidden' name='l_cd' value='<%=l_cd%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>	
    <input type='hidden' name='accid_id' value='<%=accid_id%>'>
	<input type='hidden' name="car_st" value='<%=cont.get("CAR_ST")%>'>	
	<input type='hidden' name="accid_st" value='<%=a_bean.getAccid_st()%>'>		
	<input type='hidden' name="sub_rent_gu" value='<%=a_bean.getSub_rent_gu()%>'>	
	<input type='hidden' name="sub_rent_st" value='<%=a_bean.getSub_rent_st()%>'>	
	<input type='hidden' name="sub_rent_et" value='<%=a_bean.getSub_rent_et()%>'>			
    <input type='hidden' name='mode' value='<%=mode%>'>  	
    <input type='hidden' name='go_url' value='<%=go_url%>'>  		
    <input type='hidden' name='h_accid_dt' value=''>
    <input type='hidden' name='chk_cnt' value=''>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고 개요</span>
        <%if(ck_acar_id.equals("000029")){ %>
         &nbsp;&nbsp;&nbsp;(accid_id=<%=accid_id%>)
         <%} %>
        </td>
        <td align="right">
         <%	if( nm_db.getWorkAuthUser("전산팀",user_id)  ||nm_db.getWorkAuthUser("본사관리팀장",user_id) ){%> 
	        <a href='javascript:save()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a> 
	     <%	} else { %>	     
		     <%	if(a_bean.getSettle_st().equals("0") || a_bean.getSettle_st().equals("")){%>
		        <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		        <a href='javascript:save()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a> 
		        <%	}%>	   
		     <% } %>   	     
        <%  } %>          
       
        </td>
    </tr>
    
     
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<%//if(!a_bean.getAccid_st().equals("4")){//운행자차%>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title colspan="2">사고형태</td>
                    <td width=33%> 
                      &nbsp;<select name='accid_type'>
                        <option value="">선택</option>
                        <option value="1" <%if(a_bean.getAccid_type().equals("1")){%>selected<%}%>>차대차</option>
                        <option value="2" <%if(a_bean.getAccid_type().equals("2")){%>selected<%}%>>차대사람</option>
                        <option value="3" <%if(a_bean.getAccid_type().equals("3")){%>selected<%}%>>차량단독</option>
                        <option value="4" <%if(a_bean.getAccid_type().equals("4")){%>selected<%}%>>차대열차</option>
                      </select>
                    </td>
                    <td class=title width=9%>사고일시</td>
                    <td  width=49%> 
                      &nbsp;<input type="text" name="accid_dt" value="<%=AddUtil.ChangeDate2(accid_dt)%>" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value); dt_chk();' maxlength="10">
                      <input type="text" name="accid_dt_h" size="2" value="<%=accid_dt_h%>" class=text  maxlength="2">
                      시 
                      <input type="text" name="accid_dt_m" size="2" value="<%=accid_dt_m%>" class=text   maxlength="2">
                      분 <font color="#808080">(시간:0-23)</font> </td>
                </tr>
                <tr> 
                    <td class=title colspan="2">사고장소</td>
                    <td colspan="3"> 
                      &nbsp;<select name='accid_type_sub'>
                        <option value="">선택</option>
                        <option value="1" <%if(a_bean.getAccid_type_sub().equals("1")){%>selected<%}%>>단일로</option>
                        <option value="2" <%if(a_bean.getAccid_type_sub().equals("2")){%>selected<%}%>>교차로</option>
                        <option value="3" <%if(a_bean.getAccid_type_sub().equals("3")){%>selected<%}%>>철길건널목</option>
                        <option value="4" <%if(a_bean.getAccid_type_sub().equals("4")){%>selected<%}%>>커브길</option>
                        <option value="5" <%if(a_bean.getAccid_type_sub().equals("5")){%>selected<%}%>>경사로</option>
                        <option value="6" <%if(a_bean.getAccid_type_sub().equals("6")){%>selected<%}%>>주차장</option>
                        <option value="7" <%if(a_bean.getAccid_type_sub().equals("7")){%>selected<%}%>>골목길</option>
                        <option value="8" <%if(a_bean.getAccid_type_sub().equals("8")){%>selected<%}%>>기타</option>
                      </select>
                      <input type="text" name="accid_addr" value="<%=a_bean.getAccid_addr()%>" class=text size="110">
                    </td>
                </tr>
                <tr> 
                    <td class=title width=3% rowspan="2">사고경위</td>
                    <td class=title width=6% height="76">왜?</td>
                    <td colspan="3" height="76"> 
                      &nbsp;<textarea name="accid_cont" cols="120" rows="3"><%=a_bean.getAccid_cont()%></textarea>
                    </td>
                </tr>
                <tr> 
                    <td class=title>어떻게?</td>
                    <td colspan="4"> 
                      &nbsp;<textarea name="accid_cont2" cols="120" rows="4"><%=a_bean.getAccid_cont2()%></textarea>
                    </td>
                </tr>
                <tr> 
                    <td class=title colspan="2" width=9% >과실비율</td>
                    <td >&nbsp;당사 
                      <input type="text" name="our_fault_per" value="<%=a_bean.getOur_fault_per()%>"   <% if ( a_bean.getSettle_st().equals("1")  && ( !nm_db.getWorkAuthUser("전산팀",user_id)  &&  !nm_db.getWorkAuthUser("본사관리팀장",user_id) ) ) { %>readonly <%  } %>  size="4" class=num onBlur='javascript:document.form1.ot_fault_per.value=Math.abs(toInt(this.value)-100);'>
                      : 
                      <input type="text" name="ot_fault_per" value="<%=Math.abs(a_bean.getOur_fault_per()-100)%>" <% if ( a_bean.getSettle_st().equals("1")  && ( !nm_db.getWorkAuthUser("전산팀",user_id)  &&  !nm_db.getWorkAuthUser("본사관리팀장",user_id) )  ) { %>readonly <%  } %>  size="4" class=num onBlur='javascript:document.form1.our_fault_per.value=Math.abs(toInt(this.value)-100);'>
                      상대방  
            &nbsp;&nbsp; <% if(a_bean.getPre_doc().equals("P")) {%> <font  color=red> * 과실확정전 사전결재 </font>&nbsp;&nbsp; <% } %>
                                        
				    </td>	
                    <td width=58% colspan=2> 
                      &nbsp;<select name="imp_fault_st">
                        <option value="">없음</option>
                        <option value="1" <%if(a_bean.getImp_fault_st().equals("1")){%>selected<%}%>>음주</option>
                        <option value="2" <%if(a_bean.getImp_fault_st().equals("2")){%>selected<%}%>>신호위반</option>
                        <option value="3" <%if(a_bean.getImp_fault_st().equals("3")){%>selected<%}%>>속도위반</option>
                        <option value="4" <%if(a_bean.getImp_fault_st().equals("4")){%>selected<%}%>>횡단보도</option>
                        <option value="5" <%if(a_bean.getImp_fault_st().equals("5")){%>selected<%}%>>중앙선침범</option>
                        <option value="6" <%if(a_bean.getImp_fault_st().equals("6")){%>selected<%}%>>사고후도주</option>
                        <option value="7" <%if(a_bean.getImp_fault_st().equals("7")){%>selected<%}%>>앞지르기위반</option>
                        <option value="8" <%if(a_bean.getImp_fault_st().equals("8")){%>selected<%}%>>철길</option>
                        <option value="9" <%if(a_bean.getImp_fault_st().equals("9")){%>selected<%}%>>인도</option>
                        <option value="10" <%if(a_bean.getImp_fault_st().equals("10")){%>selected<%}%>>기타</option>
                      </select>
                      <input type="text" name="imp_fault_sub"  value="<%=a_bean.getImp_fault_sub()%>"size="30" class=text>
                     &nbsp;&nbsp;
                     <font color='red' >*결재전 해지가능  </font> <input type='checkbox' name='pre_cls'  value='Y' <%if(a_bean.getPre_cls().equals("Y")){%>checked<%}%> >                  
                    </td>
                </tr>              
                    
            </table>
        </td>
    </tr>
	
	<tr>
        <td class=h></td>
    </tr>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고 당시</span></td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=9%>속도</td>
                    <td width=31%> 
                      &nbsp;<input type="text" name="speed" value="<%=a_bean.getSpeed()%>" size="4" class=num onBlur='javascript:document.form1.ot_fault_per.value=Math.abs(toInt(this.value)-100);'>
                      km/h </td>
                    <td class=title width=9%>기상조건</td>
                    <td width=51%> 
                      &nbsp;<input type="radio" name="weather" value="1" <%if(a_bean.getWeather().equals("1")){%>checked<%}%> >
                      맑음 
                      <input type="radio" name="weather" value="2" <%if(a_bean.getWeather().equals("2")){%>checked<%}%>>
                      흐림 
                      <input type="radio" name="weather" value="3" <%if(a_bean.getWeather().equals("3")){%>checked<%}%>>
                      비 
                      <input type="radio" name="weather" value="4" <%if(a_bean.getWeather().equals("4")){%>checked<%}%>>
                      안개 
                      <input type="radio" name="weather" value="5" <%if(a_bean.getWeather().equals("5")){%>checked<%}%>>
                      눈</td>
                </tr>
                <tr> 
                    <td class=title>도로조건</td>
                    <td> 
                      &nbsp;<input type="radio" name="road_stat" value="1" <%if(a_bean.getRoad_stat().equals("1")){%>checked<%}%>>
                      포장 
                      <input type="radio" name="road_stat" value="2" <%if(a_bean.getRoad_stat().equals("2")){%>checked<%}%>>
                      비포장</td>
                    <td class=title>도로면상태</td>
                    <td> 
                      &nbsp;<input type="radio" name="road_stat2" value="1" <%if(a_bean.getRoad_stat2().equals("1")){%>checked<%}%>>
                      건조 
                      <input type="radio" name="road_stat2" value="2" <%if(a_bean.getRoad_stat2().equals("2")){%>checked<%}%>>
                      습기 
                      <input type="radio" name="road_stat2" value="3" <%if(a_bean.getRoad_stat2().equals("3")){%>checked<%}%>>
                      빙설 
                      <input type="radio" name="road_stat2" value="4" <%if(a_bean.getRoad_stat2().equals("4")){%>checked<%}%>>
                      기타</td>
                </tr>
            </table>
        </td>
    </tr>
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
<script language='javascript'>
<!--
	var fm = document.form1;
	
	cont_chk();
		
	//입력값 체크
	function cont_chk(){
		
	  <%if(!rc_bean.getCar_mng_id().equals("")){//대차서비스가 있다%>
		<%	if(a_bean.getAccid_st().equals("1") || a_bean.getAccid_st().equals("3")){//피해,쌍방%>
				<%	if(my_r.length == 0){%>
				     fm.chk_cnt.value = "2";					
			     //	 fm.chk2.value = '* 대차서비스가 있는데 대차료 청구는 등록되어 있지 않습니다.';
				<%	}%>				
		    <%}%>
	   <%}%>
				
		     
		<%if(!String.valueOf(cont.get("CAR_ST")).equals("2") && ins.getCon_f_nm().equals("아마존카") && tot_sv_amt > 0 && tot_sv_req_amt == 0){%>
		<%	if(a_bean.getAccid_st().equals("1") || a_bean.getAccid_st().equals("2") || a_bean.getAccid_st().equals("3") || a_bean.getAccid_st().equals("8")) { %> //피해,가해,쌍방,단독
		<%		if(a_bean.getAccid_st().equals("1") && a_bean.getOur_fault_per()==0 ){%>//100% 피해 - 면책금없음.
		<%		}else{%>
				fm.chk_cnt.value = "1";
		     //   alert('* 사고정비는 있는데 면책금이 청구되지 않은 상태입니다.');			        
		<%		}%>	
		<%	}%>
		<%}%>
	
	}

//-->
</script>  
</body>
</html>
