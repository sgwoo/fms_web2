<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_mst.*, acar.estimate_mng.*, acar.secondhand.* , acar.user_mng.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>	
<jsp:useBean id="oh_db" 	class="acar.off_ls_hpg.OfflshpgDatabase" 	scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<% 
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String from_page2 = request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String today_dist 	= request.getParameter("today_dist")==null?"":request.getParameter("today_dist");
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
		
	EstiDatabase e_db = EstiDatabase.getInstance();
	e_bean = e_db.getEstimateCase(est_id);
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CodeBean[] goods = c_db.getCodeAll2("0009", "Y"); /* 코드 구분:대여상품명 */
	int good_size = goods.length;	
	
	//차량정보
	Hashtable ht = shDb.getShBase(car_mng_id);
	
	String jg_b_dt = e_db.getVar_b_dt(String.valueOf(ht.get("JG_CODE")), "jg", e_bean.getRent_dt());
	
	//차종변수
	ej_bean = e_db.getEstiJgVarCase(String.valueOf(ht.get("JG_CODE")), jg_b_dt);
	
	//최근 홈페이지 적용대여료 약정주행거리 20000 기본
	Hashtable hp = oh_db.getSecondhandCase_20090901("", "", car_mng_id);
	
	String max_use_mon = e_bean.getMax_use_mon();
	
	//out.println(max_use_mon);

%>
<html>
<head>
<title>조정견적</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--	

	//한도체크
	function compare(obj){
		var fm = document.form1;
		
		<%if(!e_bean.getEst_from().equals("tae_car")){%>
		
		if(obj == fm.rg_8){
											fm.rg_8_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.rg_8.value)/100);	
		}else if(obj == fm.rg_8_amt){
											var rg_8 = parseFloatCipher(toInt(parseDigit(fm.rg_8_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100,2);
											fm.rg_8.value = rg_8;	
		}else if(obj == fm.pp_per){
											fm.pp_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.pp_per.value)/100);	
		}else if(obj == fm.pp_amt){
											var pp_per = parseFloatCipher(toInt(parseDigit(fm.pp_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100,2);
											fm.pp_per.value = pp_per;												
		}		
		<%}%>
	}	
	
	//견적내기
	function EstiReg(){
		var fm = document.form1;
		
		<%if(e_bean.getEst_from().equals("tae_car")){%>
		<%}else{%>		
		//20150414 대물5억일때 메시지
		if(fm.ins_dj.value == '3'){
			alert('대물 보상한도 5억원은 계약서 작성전에 렌터카공제조합에 미리 승인을 받아야 합니다.');			
		}
		
		if(toInt(fm.a_b.value) > toInt(fm.max_use_mon.value)){
			alert('대여기간이 최대개월수보다 클 수는 없습니다.'); return;
		}
		<%}%>
		
		if(!confirm('견적하시겠습니까?')){	return; }
		fm.action = 'esti_mng_i_re_a.jsp';
		fm.target = "_self";
		fm.submit();
	}

//-->
</script>
</head>
<body leftmargin="15" onLoad="init();" >
<table border=0 cellspacing=0 cellpadding=0 width=650>
  <form action="" name="form1" method="POST" >
    <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
    <input type="hidden" name="br_id" value="<%=br_id%>">
    <input type="hidden" name="user_id" value="<%=user_id%>">
    <input type="hidden" name="gubun1" value="<%=gubun1%>">
    <input type="hidden" name="gubun2" value="<%=gubun2%>">
    <input type="hidden" name="gubun3" value="<%=gubun3%>">
    <input type="hidden" name="gubun4" value="<%=gubun4%>">
    <input type="hidden" name="gubun5" value="<%=gubun5%>">
    <input type="hidden" name="gubun6" value="<%=gubun6%>">  
    <input type="hidden" name="s_dt" value="<%=s_dt%>">
    <input type="hidden" name="e_dt" value="<%=e_dt%>">
    <input type="hidden" name="s_kd" value="<%=s_kd%>">
    <input type="hidden" name="t_wd" value="<%=t_wd%>">
    <input type="hidden" name="est_id" value="<%=est_id%>">
    <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
    <input type="hidden" name="o_1"			value="<%=e_bean.getO_1()%>">
    <input type="hidden" name="rent_dt"			value="<%=e_bean.getRent_dt()%>">
    <input type="hidden" name="br_to_st"	value="<%=e_bean.getBr_to_st()%>">
	<input type="hidden" name="br_to"		value="<%=e_bean.getBr_to()%>">
    <input type="hidden" name="br_from"	value="<%=e_bean.getBr_from()%>">
		
			
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><%if(e_bean.getEst_st().equals("2")){%>연장<%}else{%>재리스<%}%> > <span class=style5>견적 다시하기</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>	
    <tr> 
        <td colspan="2" align=right><span class=style3>* 아래 조건을 입력하고, 견적을 내시기 바랍니다.</span>&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약조건</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td colspan="2" class=title>&nbsp;</td>
                    <td class=title>조건 변경</td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>대여상품</td>
                    <td>
                      <select name="a_a">
                        <%for(int i = 0 ; i < good_size ; i++){
                            CodeBean good = goods[good_size-i-1];
                        		if(String.valueOf(hp.get("LSMAX")).equals("0") && good.getNm_cd().equals("11")) continue;
                        		if(String.valueOf(hp.get("LBMAX")).equals("0") && good.getNm_cd().equals("12")) continue;
                        		if(String.valueOf(hp.get("RSMAX")).equals("0") && good.getNm_cd().equals("21")) continue;
                        		if(String.valueOf(hp.get("RBMAX")).equals("0") && good.getNm_cd().equals("22")) continue;
                        %>
                        <option value='<%= good.getNm_cd()%>' <%if(e_bean.getA_a().equals(good.getNm_cd())){%>selected<%}%>><%= good.getNm()%></option>
                        <%}%>
                      </select>
                    </td>
                </tr>	                
                <tr> 
                    <td colspan="2" class=title>대여기간</td>
                    <td>
                      <input type="text" name="a_b" class=num size="2" value="<%=e_bean.getA_b()%>">
                      개월
                      <%if(!e_bean.getEst_from().equals("tae_car")){%>
                      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;( 최대개월수 : <%=max_use_mon%><%//=String.valueOf(hp.get("MAX_USE_MON"))==null?"":String.valueOf(hp.get("MAX_USE_MON"))%>개월 )
                      <input type="hidden" name="max_use_mon"			value="<%=max_use_mon%>"><%//=hp.get("MAX_USE_MON")==null?"":String.valueOf(hp.get("MAX_USE_MON"))%>
                      <%}%>
                      </td>
                </tr>	
                <%
              		int b_agree_dist =e_bean.getB_agree_dist();
              		int agree_dist =e_bean.getAgree_dist();
              		
									if(b_agree_dist==0){
	           							b_agree_dist = 30000;
	           							
	           							//20220415 약정운행거리 23000
	           	           				if(AddUtil.parseInt(e_bean.getRent_dt()) >= 20220415){
	           	           					b_agree_dist = 23000;
	           	           				}
           		
										//디젤 +5000
										if(ej_bean.getJg_b().equals("1")){
											b_agree_dist = b_agree_dist+5000;
										}				
										//LPG +10000 -> 20190418 +5000
										if(ej_bean.getJg_b().equals("2")){
											b_agree_dist = b_agree_dist+5000;
										}
				
										if(agree_dist==0)	agree_dist = b_agree_dist;
									}
                %>
                <tr> 
                    <td width="10%" rowspan="2" class=title>운<br>행<br>거<br>리</td>
                    <td class=title width="20%">표준약정 운행거리</td>
                    <td><input type="text" name="v_b_agree_dist" class=whitenum size="10" value='<%=AddUtil.parseDecimal(b_agree_dist)%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                        km/년
                        <input type="hidden" name="b_agree_dist"			value="<%=b_agree_dist%>">
                        </td>
                </tr>       
                <tr> 
                    <td class=title>적용약정 운행거리</td>
                    <td><input type="text" name="agree_dist" class=num size="10" value='<%=AddUtil.parseDecimal(agree_dist)%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                        km/년</td>
                </tr> 
                <tr> 
                    <td colspan="2" class=title>보증금<br> </td>                    
                    <td>
                    <%if(!e_bean.getEst_from().equals("tae_car")){%>
                      차가의 
                      <input type="text" name="rg_8" class=num size="5" onBlur="javascript:compare(this)" value="<%=e_bean.getRg_8()%>">
                      % || <%}%>적용보증금액 
                      <input type="text" name="rg_8_amt" class=num size="10" value="<%=AddUtil.parseDecimal(e_bean.getRg_8_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      원 
         					  </td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>선납금<br> </td>                    
                    <td>
                    <%if(!e_bean.getEst_from().equals("tae_car")){%>
                      차가의 
                      <input type="text" name="pp_per" class=num size="5" onBlur="javascript:compare(this)" value="<%=e_bean.getPp_per()%>">
                      % || <%}%>적용선납금액 
                      <input type="text" name="pp_amt" class=num size="10" value="<%=AddUtil.parseDecimal(e_bean.getPp_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      원 
         					  </td>
                </tr>                
                <tr> 
                    <td colspan="2" class=title >대물/자손</td>
                    <td><select name="ins_dj" >                      
                      <option value="2" <%if(e_bean.getIns_dj().equals("2")){%>selected<%}%>>1억원/1억원</option>
                      <option value="4" <%if(e_bean.getIns_dj().equals("4")){%>selected<%}%>>2억원/1억원</option>
                      <option value="8" <%if(e_bean.getIns_dj().equals("8")){%>selected<%}%>>3억원/1억원</option>
                      <option value="3" <%if(e_bean.getIns_dj().equals("3")){%>selected<%}%>>5억원/1억원</option>
                    </select>
                    </td>
                </tr>
                <tr> 
                    <td colspan="2" class=title >운전자연령</td>
                    <td><select name="ins_age">
                  <option value="1" <%if(e_bean.getIns_age().equals("1")){%>selected<%}%>>만26세이상</option>
                  <option value="3" <%if(e_bean.getIns_age().equals("3")){%>selected<%}%>>만24세이상</option>
                  <option value="2" <%if(e_bean.getIns_age().equals("2")){%>selected<%}%>>만21세이상</option>
                  </select>  
                    </td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr> 
      <td align=center colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td align=center colspan="2"><a href="javascript:EstiReg();"><img src=/acar/images/center/button_est.gif border=0 align=absmiddle></a> 
      </td>
    </tr>
  </form>
</table>
<iframe src="about:blank" name="i_no2" width="0" height="0" frameborder="0" noresize></iframe>
<script>
<!--	

//-->
</script>	
</body>
</html>
