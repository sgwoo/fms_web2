<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.tint.*, acar.user_mng.*, acar.client.*, acar.car_mst.*, acar.car_register.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();


	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String from_page2 	= request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");

	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));

	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
		
	//정상요금견적
	Hashtable esti_exam = e_db.getEstimateResultVar(f_fee_etc.getBc_est_id(), "esti_exam");
		
	//용품	
	TintBean tint1 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "1");
	TintBean tint2 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "2");
		
	//영업담당자
	UsersBean user_bean 	= umd.getUsersBean(base.getBus_id());

	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
					

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//시공구분 선택시
	function cng_input(){		  
		var fm = document.form1;
		
		if(fm.tint_yn[0].checked == false && fm.tint_yn[1].checked == false && fm.tint_yn[2].checked == false && fm.tint_yn[3].checked == false){ alert('시공구분을 선택하십시오.'); return;}
		
		if(fm.tint_yn[3].checked == true){
			fm.off_id.value = '';
		}else{
			if('<%=tint1.getTint_no()%>' == '' && '<%=tint2.getTint_no()%>' == ''){
				<%if(user_bean.getBr_id().equals("B1")||user_bean.getBr_id().equals("U1")){%>		fm.off_id.value = '010255스마일TS'; 
				<%}else if(user_bean.getBr_id().equals("D1")){%>					fm.off_id.value = '010937주식회사미성테크';
				<%}else if(user_bean.getBr_id().equals("G1")){%>					fm.off_id.value = '008501아시아나상사';
				<%}else if(user_bean.getBr_id().equals("J1")){%>					fm.off_id.value = '008680용용이자동차용품점';
				<%}else{%>										                            fm.off_id.value = '002849다옴방'; 
				<%}%>
			}			
		}				
	}
	
	//견적반영,비용부담 선택시
	function cngCostEst(st, idx){
		var fm = document.form1;
		
		//에이전트,영업사원 계약
		<%if(base.getBus_st().equals("2") || base.getBus_st().equals("7")){%>
		
		if(st == 'est_st'){
			if(fm.est_st[idx].value == 'Y'){
				fm.cost_st[idx].value = '1';
			}else{
				fm.cost_st[idx].value = '5';			
			}
		}
		
		if(st == 'cost_st'){
			if(fm.cost_st[idx].value == '1'){
				fm.est_st[idx].value = 'Y';
			}else{
				fm.est_st[idx].value = 'N';			
			}
		}
		
		
		<%}else{%>
		
		<%}%>
	}
	
	//수정
	function update(){
		var fm = document.form1;
		
		if(fm.tint_yn[0].checked == false && fm.tint_yn[1].checked == false && fm.tint_yn[2].checked == false && fm.tint_yn[3].checked == false){ alert('시공구분을 선택하십시오.'); return;}
		
		if(fm.tint_yn[3].checked == false && fm.off_id.value == ''){ alert('시공업체를 선택하십시오.'); return;}
		
		
		//측후면
		if(fm.tint_yn[0].checked == true || fm.tint_yn[2].checked == true){
		
			if(fm.film_st[0].value == '')		{ alert('측후면 필름선택을 하십시오.');			return;}
			if(fm.sun_per[0].value == '')		{ alert('측후면 가시광선투과율을 선택하십시오.');	return;}
			if(fm.cost_st[0].value == '')		{ alert('측후면 비용부담을 선택하십시오.');		return;}
			if(fm.est_st[0].value == '')		{ alert('측후면 견적반영을 선택하십시오.');		return;}
			if(fm.sup_est_dt[0].value == '')	{ alert('측후면 설치일자를 입력하십시오.');		fm.sup_est_dt[0].focus();  return;}
			if(fm.sup_est_h[0].value == '' || fm.sup_est_h[0].value == '00')	{ alert('측후면 설치일자를 입력하십시오.');			fm.sup_est_h[0].focus();  return;}
			if(fm.film_st[0].value == '4' && fm.film_st_etc[0].value == '')		{ alert('측후면 필름선택 기타의 이름을 넣어주세요.'); 		fm.film_st_etc[0].focus();  return;}
			if(fm.est_st[0].value == 'Y' && toInt(fm.est_m_amt[0].value) == 0)	{ alert('측후면 견적반영이면 월반영금액을 입력해주세요.'); 	fm.est_m_amt[0].focus();  return;}					

		}
		
		//전면
		if(fm.tint_yn[1].checked == true || fm.tint_yn[2].checked == true){

			if(fm.film_st[1].value == '')		{ alert('전면 필름선택을 하십시오.');			return;}
			if(fm.sun_per[1].value == '')		{ alert('전면 가시광선투과율을 선택하십시오.');		return;}
			if(fm.cost_st[1].value == '')		{ alert('전면 비용부담을 선택하십시오.');		return;}
			if(fm.est_st[1].value == '')		{ alert('전면 견적반영을 선택하십시오.');		return;}
			if(fm.sup_est_dt[1].value == '')	{ alert('전면 설치일자를 입력하십시오.');		fm.sup_est_dt[1].focus();  return;}
			if(fm.sup_est_h[1].value == '' || fm.sup_est_h[1].value == '00')	{ alert('전면 설치일자를 입력하십시오.');			fm.sup_est_h[1].focus();  return;}		
			if(fm.film_st[1].value == '4' && fm.film_st_etc[1].value == '')		{ alert('전면 필름선택 기타의 이름을 넣어주세요.'); 		fm.film_st_etc[1].focus();  return;}
			if(fm.est_st[1].value == 'Y' && toInt(fm.est_m_amt[1].value) == 0)	{ alert('전면 견적반영이면 월반영금액을 입력해주세요.'); 	fm.est_m_amt[1].focus();  return;}
			
		}
		
				
		if(confirm('수정하시겠습니까?')){	
			fm.action='lc_c_u_tint1_a.jsp';		
			//fm.target='i_no';
			fm.submit();
		}									
	}			
				
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='lc_c_u_tint1_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 			value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 			value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 			value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 			value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type='hidden' name='from_page2'	 	value='<%=from_page2%>'>   
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
     
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>용품의뢰 수정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
	<td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>계약번호</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>상호</td>
                    <td width=20%>&nbsp;<%=client.getFirm_nm()%></td>
                    <td class=title width=10%><%if(cr_bean.getCar_no().equals("")){%>차명<%}else{%>차량번호<%}%></td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                </tr>
  	    </table>
	 </td>
    </tr>  	                  
    <tr>
        <td class=h></td>
    </tr>  
	<td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>      
                <tr> 
                    <td class=title width=13%>견적반영용품</td>
                    <td>&nbsp;
                    	<%if(car.getTint_s_yn().equals("Y")){%>
                    	<label><input type="checkbox" name="tint_s_yn" value="Y" <%if(car.getTint_s_yn().equals("Y")){%>checked<%}%>> 전면 썬팅(기본형)</label>,
                        가시광선투과율 :
                        <input type='text' name="tint_s_per" value='<%=car.getTint_s_per()%>' size="4" maxlength="4" class='text'>
        	              % 
      		              &nbsp;
      		            <%}%>  
      		            <%if(car.getTint_ps_yn().equals("Y")){%>
      		            <label><input type="checkbox" name="tint_ps_yn" value="Y" <%if(car.getTint_ps_yn().equals("Y")){%>checked<%}%>> 고급썬팅</label>&nbsp;&nbsp;
      		            내용 <%=car.getTint_ps_nm()%>&nbsp; 금액 <%=AddUtil.parseDecimal(car.getTint_ps_amt())%> 원 (부가세별도)
					        	  <%}%>      	
					          </td>
                </tr>                
  	    </table>
	 </td>
    </tr>  	  
    <tr>
	<td align="right">&nbsp;</td>
    <tr>
    <input type='hidden' name="tint_no"	 		value="<%=tint1.getTint_no()%>">
    <input type='hidden' name="tint_no"	 		value="<%=tint2.getTint_no()%>">
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle><span class=style2>썬팅(측후면/전면)</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td colspan='2' class='title'>시공구분</td>
                    <td width='37%' >&nbsp;
                        <%if(tint1.getTint_no().equals("")) tint1.setTint_yn("Y"); %>
                        <%if(tint2.getTint_no().equals("")) tint2.setTint_yn(car.getTint_s_yn()==""?"N":car.getTint_s_yn()); %>
                        <input type='radio' name="tint_yn" value='1' onClick="javascript:cng_input()" <%if(tint1.getTint_yn().equals("Y") && tint2.getTint_yn().equals("N"))%>checked<%%>>측후면
                        <input type='radio' name="tint_yn" value='2' onClick="javascript:cng_input()" <%if(tint1.getTint_yn().equals("N") && tint2.getTint_yn().equals("Y"))%>checked<%%>>전면
                        <input type='radio' name="tint_yn" value='3' onClick="javascript:cng_input()" <%if(tint1.getTint_yn().equals("Y") && tint2.getTint_yn().equals("Y"))%>checked<%%>>측후면+전면
                        <input type='radio' name="tint_yn" value='N' onClick="javascript:cng_input()" <%if(tint1.getTint_yn().equals("N") && tint2.getTint_yn().equals("N"))%>checked<%%>>시공하지않음
                    </td>
                    <td colspan='2' class='title'>시공업체</td>
                    <td colspan='2' width='37%'>&nbsp;
                        <select name='off_id' class='default'>
                            <option value="">선택</option>
                            <option value="002849다옴방"        <%if(tint1.getOff_id().equals("002849") || tint2.getOff_id().equals("002849"))%>selected<%%>>다옴방(수도권)		</option>
                            <option value="010255스마일TS"     <%if(tint1.getOff_id().equals("010255") || tint2.getOff_id().equals("010255"))%>selected<%%>>스마일TS(부산)	</option>
                            <option value="010937주식회사미성테크"  <%if(tint1.getOff_id().equals("010937") || tint2.getOff_id().equals("010937"))%>selected<%%>>주식회사미성테크(대전)</option>
                            <option value="008501아시아나상사"    <%if(tint1.getOff_id().equals("008501") || tint2.getOff_id().equals("008501"))%>selected<%%>>아시아나상사(대구)	</option>
                            <option value="008680용용이자동차용품점" <%if(tint1.getOff_id().equals("008680") || tint2.getOff_id().equals("008680"))%>selected<%%>>용용이자동차용품점(광주)	</option>
                            <option value="002850유림카랜드"     <%if(tint1.getOff_id().equals("002850") || tint2.getOff_id().equals("002850"))%>selected<%%>>유림카랜드(부산)	</option>
                            <option value="999991수입차"        <%if(tint1.getOff_id().equals("999991") || tint2.getOff_id().equals("999991"))%>selected<%%>>수입차	        </option>
                            <option value="999992고객장착"       <%if(tint1.getOff_id().equals("999992") || tint2.getOff_id().equals("999992"))%>selected<%%>>고객장착	</option>
			                      <%if(tint1.getOff_id().equals("008692") || tint2.getOff_id().equals("008692")){%>
			                      <option value="008692주식회사오토카샵" <%if(tint1.getOff_id().equals("008692") || tint2.getOff_id().equals("008692"))%>selected<%%>>주식회사 오토카샵</option>
			                      <%}%>
			                      <%if(tint1.getOff_id().equals("002851") || tint2.getOff_id().equals("002851")){%>
        		                <option value="002851웰스킨천연가죽"  <%if(tint1.getOff_id().equals("002851") || tint2.getOff_id().equals("002851"))%>selected<%%>>웰스킨천연가죽	</option>
			                      <%}%>
			                      <%if(tint1.getOff_id().equals("008514") || tint2.getOff_id().equals("008514")){%>
			                      <option value="008514대호4WD상사"   <%if(tint1.getOff_id().equals("008514") || tint2.getOff_id().equals("008514"))%>selected<%%>>대호4WD상사	</option>
			                      <%}%>
                        </select>
                    </td>
                </tr>                
                <tr> 
                    <td rowspan='2' width='7%' class='title'>필름선택</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
                        <select name='film_st' class='default'>
                            <option value="">선택</option>
                            <option value="2" <%if(tint1.getFilm_st().equals("2"))%>selected<%%>>3M</option>
        		    <option value="3" <%if(tint1.getFilm_st().equals("3"))%>selected<%%>>루마</option>
        		    <option value="5" <%if(tint1.getFilm_st().equals("5"))%>selected<%%>>솔라가드</option>
        		    <option value="6" <%if(tint1.getFilm_st().equals("6"))%>selected<%%>>고급</option>
        		    <option value="4" <%if(tint1.getFilm_st().equals("4"))%>selected<%%>>기타</option>
                        </select>                    
                        (내용:<input type='text' name='film_st_etc' size='20' value='<%=tint1.getFilm_st()%>' class='default' >)
                    </td>
                    <td rowspan='2' width='7%' class='title'>가시광선<br>투과율</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
                        <%if(tint1.getTint_no().equals("")) tint1.setSun_per(car.getSun_per()); %>
                        <select name='sun_per' class='default'>
                            <option value="">선택</option>
                            <option value="5" <%if(tint1.getSun_per() == 5)%>selected<%%>>5%</option>
                            <option value="15" <%if(tint1.getSun_per() == 15)%>selected<%%>>15%</option>
        		    <option value="35" <%if(tint1.getSun_per() == 35)%>selected<%%>>35%</option>
        		    <option value="50" <%if(tint1.getSun_per() == 50)%>selected<%%>>50%</option>
                        </select>                    
                    </td>
                </tr>
                <tr> 
                    <td class='title'>전면</td>
                    <td>&nbsp;
                        <select name='film_st' class='default'>
                            <option value="">선택</option>
                            <option value="2" <%if(tint2.getFilm_st().equals("2"))%>selected<%%>>3M</option>
        		    <option value="3" <%if(tint2.getFilm_st().equals("3"))%>selected<%%>>루마</option>
        		    <option value="5" <%if(tint2.getFilm_st().equals("5"))%>selected<%%>>솔라가드</option>
        		    <option value="6" <%if(tint2.getFilm_st().equals("6"))%>selected<%%>>고급</option>
        		    <option value="4" <%if(tint2.getFilm_st().equals("4"))%>selected<%%>>기타</option>
                        </select>                    
                        (내용:<input type='text' name='film_st_etc' size='20' value='<%=tint2.getFilm_st()%>' class='default' >)
                    </td>
                    <td class='title'>전면</td>
                    <td>&nbsp;
                        <%if(tint2.getTint_no().equals("")) tint2.setSun_per(car.getTint_s_per()); %>
                        <select name='sun_per' class='default'>
                            <option value="">선택</option>
                            <option value="15" <%if(tint2.getSun_per() == 15)%>selected<%%>>15%</option>
        		    <option value="35" <%if(tint2.getSun_per() == 35)%>selected<%%>>35%</option>
        		    <option value="50" <%if(tint2.getSun_per() == 50)%>selected<%%>>50%</option>
                        </select>                                        
                    </td>
                </tr>
                <tr> 
                    <td rowspan='2' width='7%' class='title'>비용부담</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
                        <%if(tint1.getTint_no().equals("")) tint1.setCost_st("1"); %>
                        <select name='cost_st' class='default'>
                            <option value="">선택</option>
                            <option value="1" <%if(tint1.getCost_st().equals("1"))%>selected<%%>>없음</option>
                            <%if(base.getCar_st().equals("2") || (!base.getBus_st().equals("2") && !base.getBus_st().equals("7"))){%>
        		    <option value="2" <%if(tint1.getCost_st().equals("2"))%>selected<%%>>고객</option>
        		    <option value="4" <%if(tint1.getCost_st().equals("4"))%>selected<%%>>당사</option>
        		    <%}%>
        		    <option value="5" <%if(tint1.getCost_st().equals("5"))%>selected<%%>>에이전트</option>
                        </select>                                        
                    </td>
                    <td rowspan='2' width='7%' class='title'>견적반영</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
                        <%if(tint1.getTint_no().equals("")) tint1.setEst_st("N"); %>
                        <select name='est_st' class='default'>
                            <option value="">선택</option>
                            <option value="Y" <%if(tint1.getEst_st().equals("Y"))%>selected<%%>>반영</option>
        		    <option value="N" <%if(tint1.getEst_st().equals("N"))%>selected<%%>>미반영</option>        		    
                        </select>     
                        (반영:월<input type='text' name='est_m_amt' size='10' class='defaultnum' value='<%=AddUtil.parseDecimal(tint1.getEst_m_amt())%>'>원)
                    </td>
                </tr>
                <tr> 
                    <td class='title'>전면</td>
                    <td>&nbsp;
                        <%if(tint2.getTint_no().equals("") && (car.getTint_s_yn().equals("Y")||car.getTint_ps_yn().equals("Y"))) tint2.setCost_st("1"); %>                        
                        <select name='cost_st' class='default' onChange="javascript:cngCostEst('cost_st',1);">
                            <option value="">선택</option>
                            <option value="1" <%if(tint2.getCost_st().equals("1"))%>selected<%%>>없음</option>
                            <%if(base.getCar_st().equals("2") || (!base.getBus_st().equals("2") && !base.getBus_st().equals("7"))){%>
        		    <option value="2" <%if(tint2.getCost_st().equals("2"))%>selected<%%>>고객</option>
        		    <option value="4" <%if(tint2.getCost_st().equals("4"))%>selected<%%>>당사</option>
        		    <%}%>
        		    <option value="5" <%if(tint2.getCost_st().equals("5"))%>selected<%%>>에이전트</option>
                        </select>                                                                             
                    </td>
                    <td class='title'>전면</td>
                    <td>&nbsp;
                        <%if(tint2.getTint_no().equals("") && (car.getTint_s_yn().equals("Y")||car.getTint_ps_yn().equals("Y"))) tint2.setEst_st("Y"); %>
                        <%if(tint2.getTint_no().equals("") && car.getTint_s_yn().equals("Y") && AddUtil.parseInt(String.valueOf(esti_exam.get("AX117_S"))==null?"":String.valueOf(esti_exam.get("AX117_S"))) >0) tint2.setEst_m_amt(AddUtil.parseInt(String.valueOf(esti_exam.get("AX117_S")))); %>
                        <%if(tint2.getTint_no().equals("") && car.getTint_ps_yn().equals("Y") && AddUtil.parseInt(String.valueOf(esti_exam.get("AX117_PS"))==null?"":String.valueOf(esti_exam.get("AX117_PS"))) >0) tint2.setEst_m_amt(AddUtil.parseInt(String.valueOf(esti_exam.get("AX117_PS")))); %>
                        <select name='est_st' class='default' onChange="javascript:cngCostEst('est_st',1);">
                            <option value="">선택</option>
                            <option value="Y" <%if(tint2.getEst_st().equals("Y"))%>selected<%%>>반영</option>
        		    <option value="N" <%if(tint2.getEst_st().equals("N"))%>selected<%%>>미반영</option>        		    
                        </select>     
                        (반영:월<input type='text' name='est_m_amt' size='10' class='defaultnum' value='<%=AddUtil.parseDecimal(tint2.getEst_m_amt())%>'>원)
                    </td>
                </tr>
                <tr> 
                    <td rowspan='2' width='7%' class='title'>설치일자</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
                        <input type='text' size='11' name='sup_est_dt' maxlength='10' class='default' <%if(tint1.getSup_est_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint1.getSup_est_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
        		<input type='text' size='2' name='sup_est_h' maxlength='2' class='default' value=<%if(tint1.getSup_est_dt().length()==10){%>'<%=tint1.getSup_est_dt().substring(8)%>'<%}%>>시까지 요청함
                    </td>
                    <td rowspan='2' width='7%' class='title'>설치비용</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(tint1.getTint_amt())%>원</td>
                </tr>
                <tr> 
                    <td class='title'>전면</td>
                    <td>&nbsp;
                        <input type='text' size='11' name='sup_est_dt' maxlength='10' class='default' <%if(tint2.getSup_est_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint2.getSup_est_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
        		<input type='text' size='2' name='sup_est_h' maxlength='2' class='default' value=<%if(tint2.getSup_est_dt().length()==10){%>'<%=tint2.getSup_est_dt().substring(8)%>'<%}%>>시까지 요청함
                    </td>
                    <td class='title'>전면</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(tint2.getTint_amt())%>원</td>
                </tr>    
                <tr> 
                    <td colspan='2' class='title'>비고</td>
                    <td colspan='4'>&nbsp;
                        <input type='text' name='etc' size='100' value='<%=tint1.getEtc()%>' class='default' ></td>
                </tr>                                 
                            
            </table>
	</td>
    </tr>    
    <tr>
	<td>* 비용부담 : 견적 미반영인 경우 별도 비용이 발생하면 그 비용을 부담할 주체가 누구 인지를 입력하세요. 제조사 썬팅은 없음입니다.</td>
    </tr>	
    <tr>
	<td>* 제조사 썬팅인 경우에도 등록하여 주십시오. (비용분담-없음, 견적반영-미반영)</td>
    </tr>	
    <tr>
	<td align='center'>&nbsp;</td>
    </tr>	
    <tr>
        <td align='center'>
        <%if(tint1.getPay_dt().equals("") && tint2.getPay_dt().equals("")){%>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	  	<a href='javascript:update();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a> 
	  	&nbsp;
	    <%}%>
	    <%}%>
	    <a href='javascript:window.close();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a> 
  	</td>
    </tr>            
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	cng_input();
//-->
</script>
</body>
</html>