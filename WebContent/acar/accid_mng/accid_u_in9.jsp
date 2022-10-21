<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.accid.*, acar.user_mng.*, acar.car_service.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="oa_bean" class="acar.accid.OtAccidBean" scope="page"/>
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
	String mode = request.getParameter("mode")==null?"9":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String dlv_mon = request.getParameter("dlv_mon")==null?"":request.getParameter("dlv_mon");
	String car_amt = request.getParameter("car_amt")==null?"":request.getParameter("car_amt");
	String tot_amt = request.getParameter("tot_amt")==null?"":request.getParameter("tot_amt");
	String req_est_amt = request.getParameter("req_est_amt")==null?"":request.getParameter("req_est_amt");
	String amor_est_id = request.getParameter("amor_est_id")==null?"":request.getParameter("amor_est_id");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "02");
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//사고조회
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	
	String accid_dt = a_bean.getAccid_dt().substring(0,8);
//	out.println(accid_dt);
	
	
	//정비/점검(면책금)
	ServiceBean s_r [] = as_db.getServiceList(c_id, accid_id);
	ServiceBean s_bean = as_db.getService(c_id, accid_id);
	
	//상대차량 인적사항
	OtAccidBean oa_r [] = as_db.getOtAccid(c_id, accid_id);
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();
	
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
		if(fm.accid_id.value == ''){ alert("상단을 먼저 등록하십시오."); return; }
		if(!confirm('수정하시겠습니까?')){
			return;
		}
		fm.target = "i_no"
		fm.submit();
	}
	
	//지급보험금 합계 셋팅
/*	function set_accid_tot_amt(obj){
		var fm = document.form1;
		fm.ex_tot_amt.value = parseDecimal(toInt(parseDigit(fm.hum_amt.value)) + toInt(parseDigit(fm.mat_amt.value)) + toInt(parseDigit(fm.one_amt.value)));
		fm.tot_amt.value = parseDecimal(toInt(parseDigit(fm.hum_amt.value)) + toInt(parseDigit(fm.mat_amt.value)) + toInt(parseDigit(fm.one_amt.value)) + toInt(parseDigit(fm.my_amt.value)));
	}*/
	
	function estimates_view(est_id){
		var SUBWIN="/acar/estimate_mng/esti_mng_i_a_3_result_caramt_20110627.jsp?est_id="+est_id+"&esti_table=estimate_sh";
		window.open(SUBWIN, "ResultView", "left=100, top=100, width=700, height=<%=s_height%>, scrollbars=yes, status=yes, resizable=yes");
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
    <input type='hidden' name='mode' value='<%=mode%>'>
    <input type='hidden' name='cmd' value='<%=cmd%>'>
    <input type='hidden' name='go_url' value='<%=go_url%>'>  		
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험처리결과</span></td>
        <td align="right">
        <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href='javascript:save()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a> 
        <%	}%>
        </td>
    </tr>
    	<tr>
	    <td class=line2 colspan=2></td>
	</tr>
	<%if(a_bean.getAccid_st().equals("1") || a_bean.getAccid_st().equals("2") || a_bean.getAccid_st().equals("3")){//가해,쌍방%>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title colspan="2">구분</td>
                    <td class=title colspan="2">보상금액</td>
                    <td class=title width=15%>보상완료일</td>
                    <td class=title width=15%>담당자</td>
                    <td class=title width=16%>연락처</td>
                </tr>
                <tr> 
                    <td class=title rowspan="4" width=9%>보험사</td>
                    <td class=title width=9%>대인</td>
                    <td align="center" width=18%> 
                      <input type="text" name="hum_amt" value="<%=AddUtil.parseDecimal(a_bean.getHum_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_accid_tot_amt();'>
                      원</td>
                    <td align="center" rowspan="4" width=18%> 
                      <input type="text" name="ex_tot_amt" value="<%=AddUtil.parseDecimal(a_bean.getEx_tot_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_accid_tot_amt();'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="hum_end_dt" value="<%=AddUtil.ChangeDate2(a_bean.getHum_end_dt())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="hum_nm" value="<%=AddUtil.ChangeDate2(a_bean.getHum_nm())%>" size="15" class=text>
                    </td>
                    <td align="center"> 
                      <input type="text" name="hum_tel" value="<%=AddUtil.ChangeDate2(a_bean.getHum_tel())%>" size="13" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>대물</td>
                    <td align="center"> 
                      <input type="text" name="mat_amt" value="<%=AddUtil.parseDecimal(a_bean.getMat_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_accid_tot_amt();'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="mat_end_dt" value="<%=AddUtil.ChangeDate2(a_bean.getMat_end_dt())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="mat_nm" value="<%=AddUtil.ChangeDate2(a_bean.getMat_nm())%>" size="15" class=text>
                    </td>
                    <td align="center"> 
                      <input type="text" name="mat_tel" value="<%=AddUtil.ChangeDate2(a_bean.getMat_tel())%>" size="13" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>자손</td>
                    <td align="center"> 
                      <input type="text" name="one_amt" value="<%=AddUtil.parseDecimal(a_bean.getOne_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_accid_tot_amt();'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="one_end_dt" value="<%=AddUtil.ChangeDate2(a_bean.getOne_end_dt())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="one_nm" value="<%=AddUtil.ChangeDate2(a_bean.getOne_nm())%>" size="15" class=text>
                    </td>
                    <td align="center"> 
                      <input type="text" name="one_tel" value="<%=AddUtil.ChangeDate2(a_bean.getOne_tel())%>" size="13" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>자차</td>
                    <td align="center"> 
                      <input type="text" name="my_amt" value="<%=AddUtil.parseDecimal(a_bean.getMy_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_accid_tot_amt();'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="my_end_dt" value="<%=AddUtil.ChangeDate2(a_bean.getMy_end_dt())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="my_nm" value="<%=AddUtil.ChangeDate2(a_bean.getMy_nm())%>" size="15" class=text>
                    </td>
                    <td align="center"> 
                      <input type="text" name="my_tel" value="<%=AddUtil.ChangeDate2(a_bean.getMy_tel())%>" size="13" class=text>
                    </td>
                </tr>				
                <tr> 
                    <td class=title>아마존카</td>
                    <td class=title>자차</td>
                    <td align="center">- </td>
                    <td align="center"> 
                      <input type="text" name="my_amt2" value="<%=AddUtil.parseDecimal(s_bean.getTot_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_accid_tot_amt();'>
                      원</td>
                    <td align="center"><%=AddUtil.ChangeDate2(s_bean.getSet_dt())%></td>
                    <td align="center"><%=s_bean.getOff_nm()%></td>
                    <td align="center"> -</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">합계</td>
                    <td align="center">- </td>
                    <td align="center"> 
                      <input type="text" name="tot_amt" value="<%=AddUtil.parseDecimal(a_bean.getTot_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                </tr>
            </table>
        </td>
    </tr>
    <script language="JavaScript">
    <!--
    	//지급보험금 합계 셋팅
    	function set_accid_tot_amt(){
    		var fm = document.form1;
    		fm.ex_tot_amt.value = parseDecimal(toInt(parseDigit(fm.hum_amt.value)) + toInt(parseDigit(fm.mat_amt.value)) + toInt(parseDigit(fm.one_amt.value)) + toInt(parseDigit(fm.my_amt.value)));
    		fm.tot_amt.value = parseDecimal(toInt(parseDigit(fm.hum_amt.value)) + toInt(parseDigit(fm.mat_amt.value)) + toInt(parseDigit(fm.one_amt.value)) + toInt(parseDigit(fm.my_amt.value)) + toInt(parseDigit(fm.my_amt2.value)));
    	}
    	
    	set_accid_tot_amt();
    //-->
    </script>	
    	<%}else{%>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title colspan="2">구분</td>
                    <td class=title colspan="2">보상금액</td>
                    <td class=title width=15%>보상완료일</td>
                    <td class=title width=15%>담당자</td>
                    <td class=title width=16%>연락처</td>
                </tr>
                <tr> 
                    <td class=title width=9%>아마존카</td>
                    <td class=title width=9%>자차</td>
                    <td align="center" width=18%>- </td>
                    <td align="center" width=18%> 
                      <input type="text" name="my_amt2" value="<%=AddUtil.parseDecimal(a_bean.getMy_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_accid_tot_amt();'>
                      원</td>
                    <td align="center"><%=AddUtil.ChangeDate2(s_bean.getSet_dt())%></td>
                    <td align="center"><%=s_bean.getOff_nm()%></td>
                    <td align="center"> -</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">합계</td>
                    <td align="center">- </td>
                    <td align="center"> 
                      <input type="text" name="tot_amt" value="<%=AddUtil.parseDecimal(a_bean.getTot_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                </tr>
            </table>
        </td>
    </tr>
<script language="JavaScript">
<!--
	//지급보험금 합계 셋팅
	function set_accid_tot_amt(){
		var fm = document.form1;
		fm.tot_amt.value = parseDecimal(toInt(parseDigit(fm.my_amt2.value)));
	}
	
	set_accid_tot_amt();
//-->
</script>		
	<%}%>	
	<tr>
	    <td class=h></td>
	</tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>격락손해 || 차량파손보상금 청구</span>&nbsp;(피해/쌍방일때)</td>
        <td align="right">
        </td>
    </tr>
    	<tr>
	    <td class=line2 colspan=2></td>
	</tr>
	<%if(a_bean.getAccid_st().equals("1") || a_bean.getAccid_st().equals("3")){//피해,쌍방 상대과실%>

    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title colspan="2">구분</td>
                    <td class=title>금액</td>
                    <td class=title>일자</td>
                    <td class=title width=15%>상대보험사</td>
                    <td class=title width=15%>담당자</td>
                    <td class=title width=16%>연락처</td>
                </tr>
				<%	int amor_req_tot_amt = 0;
					if(oa_r.length > 0){
						for(int i=0; i<oa_r.length; i++){
    						oa_bean = oa_r[i];
							amor_req_tot_amt += oa_bean.getAmor_req_amt();
				%>	
                <tr> 
                    <td width=9% rowspan="4" class=title>상대차량(<%=i+1%>)<input type='hidden' name='seq_no' value='<%=oa_bean.getSeq_no()%>'></td>
                    <td width=9% class=title>항목</td>
                    <td colspan="2">&nbsp;
                      <select name='amor_type'>
                        <option value="">선택</option>
                        <option value="1" <%if(oa_bean.getAmor_type().equals("1"))%> selected<%%>>격락손해배상</option>
                        <option value="2" <%if(oa_bean.getAmor_type().equals("2"))%> selected<%%>>차량파손배상(폐차)</option>
                      </select></td>
                    <td rowspan="4" align="center"><input type="text" name="ot_ins" value="<%=oa_bean.getOt_ins()%>" size="15" class=text maxlength="20" ></td>
                    <td rowspan="4" align="center"><input type="text" name="ot_mat_nm" value="<%=oa_bean.getMat_nm()%>" size="15" class=text maxlength="10" ></td>
                    <td rowspan="4" align="center"><input type="text" name="ot_mat_tel" value="<%=oa_bean.getMat_tel()%>" size="15" class=text maxlength="15" ></td>
                </tr>
                <tr>
                  <td class=title>청구여부</td>
                  <td colspan="2">&nbsp;
                    <select name='amor_st'>
                      <option value="">선택</option>
                      <option value="Y" <%if(oa_bean.getAmor_st().equals("Y"))%> selected<%%>>청구한다</option>
                      <option value="N" <%if(oa_bean.getAmor_st().equals("N"))%> selected<%%>>청구안한다</option>
                    </select>
&nbsp; 청구자 :
<select name='amor_req_id'>
  <option value="">선택</option>
  <%	if(user_size > 0){
        						for (int j = 0 ; j < user_size ; j++){
        							Hashtable user = (Hashtable)users.elementAt(j);	%>
  <option value='<%=user.get("USER_ID")%>' <%if(oa_bean.getAmor_req_id().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
  <%		}
        					}		%>
</select></td>
                </tr>
                <tr>
                  <td class=title>청구</td>
                  <td width=18% align="center">
				    <input type="text" name="amor_req_amt" value="<%=AddUtil.parseDecimal(oa_bean.getAmor_req_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_accid_tot_amt();'>
                    원</td>
                  <td width=18% align="center">
				    <input type="text" name="amor_req_dt" value="<%=AddUtil.ChangeDate2(oa_bean.getAmor_req_dt())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>
                <tr>
                  <td width=9% class=title>입금</td>
                  <td align="center">
				    <input type="text" name="amor_pay_amt"  <% if( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사출납",user_id) ){%> <% } else { %> readonly <%} %> value="<%=AddUtil.parseDecimal(oa_bean.getAmor_pay_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_accid_tot_amt();'>
                    원</td>
                  <td align="center" width=18%>
				    <input type="text" name="amor_pay_dt"  <% if( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사출납",user_id) ){%> <% } else { %> readonly <%} %> value="<%=AddUtil.ChangeDate2(oa_bean.getAmor_pay_dt())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>
				<%		}
					}%>
            </table>
        </td>
    </tr>	
	<%	if(amor_req_tot_amt==0 && req_est_amt.equals("")){
			//Vector accid_case = as_db.getAccidS8List2("", "", "", "", "", "", "", "", "", "", "accid_id", c_id+""+accid_id, "", "", "");
			//for (int i = 0 ; i < accid_case.size() ; i++){
				//Hashtable accid_1 = (Hashtable)accid_case.elementAt(i);
				Hashtable accid_1 = as_db.getAccidAmor(c_id, accid_id, accid_dt);
				dlv_mon 	= String.valueOf(accid_1.get("DLV_MON"));
				car_amt 	= String.valueOf(accid_1.get("CAR_AMT"));
				tot_amt 	= String.valueOf(accid_1.get("TOT_AMT"));
				req_est_amt = String.valueOf(accid_1.get("REQ_EST_AMT"));
				amor_est_id = String.valueOf(accid_1.get("AMOR_EST_ID"));
			//}
		}%>		
	<%	if(s_r.length>0 && amor_req_tot_amt==0 && !req_est_amt.equals("0") && !req_est_amt.equals("")){%>
  	<tr>
	    <td colspan=2>※ 출고경과 : <%=dlv_mon%>년이내 / 차량잔가 : <%=AddUtil.parseDecimal(car_amt)%>원 <span class="b"><a href="javascript:estimates_view('<%=amor_est_id%>')" onMouseOver="window.status=''; return true" title="견적결과 보기"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span> 
		/ 수리비용 : <%=AddUtil.parseDecimal(tot_amt)%>원 / 청구가능금액 : <%=AddUtil.parseDecimal(req_est_amt)%>원
		
		</td>
	</tr>	
	<%	}%>
	<%}%>
  	<tr>
	    <td colspan=2><font color=red>※ 피해자동차 시세하락손해 보상이 확대 되었습니다 (조건 : 차량등록증상 차량가격의 20% 이상의 수리비)</font></td>
	</tr>	
	<tr>
	    <td colspan=2>&nbsp;&nbsp;기존 : 등록일 기준 2년 이내 자동차   1년 15% , 2년 10%</td>
	</tr>	
	<tr>
	    <td colspan=2>&nbsp;&nbsp;변경 : 등록일 기준 5년 이내 자동차   1년 20% , 2년 15% , 2년초과 5년까지 10% (2019년05월01일 사고건 부터 적용)</td>
	</tr>	
			
  	<tr>
	    <td colspan=2>※ 차량파손배상 : 수리가 불가능한 경우 교환가치의 감소액에 대한 보상.(폐차)</td>
	</tr>			
  	<tr>
	    <td colspan=2>※ 격락손해 및 차량파손배상은 상대운전자를 선등록한 후 등록할 수 있습니다.</td>
	</tr>			
	<%-- <%if(a_bean.getSettle_st().equals("1")){//사고종료일때는 수정못하게 막음..%>		 --%>
   	<tr>
	    <td colspan=2>※ 사고종료건입니다. <!-- 사고종료후에는 격락손해청구를 수정할수 없습니다. 수정분이 발생하면 전산팀에 문의하세요. --></td>
	</tr> -		
<%-- 	<%}%> --%>
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
