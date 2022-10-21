<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.tint.*, acar.doc_settle.*, acar.car_office.*, acar.cls.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%

	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String tint_no 	= request.getParameter("tint_no")==null?"":request.getParameter("tint_no");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//용품관리
	TintBean tint 	= t_db.getTint(tint_no);
	
	if(tint_no.equals("")){
		tint 	= t_db.getTint(rent_mng_id, rent_l_cd);
		tint_no = tint.getTint_no();
	}
	
	if(rent_mng_id.equals("")){
		rent_mng_id = tint.getRent_mng_id();
		rent_l_cd 	= tint.getRent_l_cd();
	}
	
	//문서관리
	DocSettleBean doc = d_db.getDocSettleCommi("6", tint_no);
	
	//일정관리
	Hashtable est = a_db.getRentEst(rent_mng_id, rent_l_cd);
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//해지정보
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);	
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
	var popObj = null;
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}		
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL;
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();			
	}	


	//리스트
	function list(){
		var fm = document.form1;	
		if('<%=from_page%>' == ''){		
			fm.action = 'tint_i_frame.jsp';
		}else{
			fm.action = '<%=from_page%>';
		}
		fm.target = 'd_content';
		fm.submit();
	}	

	//총금액계산
	function set_tot_amt(){
		var fm = document.form1;
		fm.tot_amt.value = parseDecimal(toInt(parseDigit(fm.tint_amt.value)) + toInt(parseDigit(fm.cleaner_amt.value)) + toInt(parseDigit(fm.navi_amt.value)) + toInt(parseDigit(fm.blackbox_amt.value)) + toInt(parseDigit(fm.other_amt.value)));
	}
	
	//등록
	function save(mode){
		var fm = document.form1;
		
		fm.mode.value = mode;
		
		if(fm.sup_est_dt.value  != ''  && fm.sup_est_h.value  == '') 		fm.sup_est_h.value 	= '00';		
		
		if(mode == 'settle'){
			if(fm.sup_dt.value  != ''  && fm.sup_h.value  == '') 		fm.sup_h.value 	= '00';		
			
			if(fm.sup_dt.value == '')	{	alert('작업마감일시를 입력하여 주십시오.');		fm.sup_dt.focus(); 			return;		}
			//if(fm.tot_amt.value == '0')	{	alert('청구금액을 입력하여 주십시오.');		fm.tot_amt.focus(); 		return;		}

			if(!confirm('정산 하시겠습니까?'))	return;
			
		}else{
			if(!confirm('수정 하시겠습니까?'))	return;		
		}
		
		fm.action='tint_reg_step2_a.jsp';		
		fm.target='i_no';
		fm.submit();
	}				
	
	//삭제
	function del_tint(){
		var fm = document.form1;
		
		if(!confirm('삭제 하시겠습니까?'))	return;
		if(!confirm('진짜로 삭제 하시겠습니까?'))	return;
		if(!confirm('마지막으로 묻습니다. 삭제 하시겠습니까?'))	return;				
		
		fm.action='tint_delete.jsp';		
		fm.target='i_no';
		fm.submit();

	}
	
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">

  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='from_page'	value='<%=from_page%>'>        
  <input type='hidden' name='mode' 		value='<%=mode%>'>            
  <input type='hidden' name='tint_no' 	value='<%=tint_no%>'>
  <input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
  <input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>  
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="car_nm" 		value="<%=cm_bean.getCar_nm()%>">
  
 <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
      <td>
    	<table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > 용품관리 > <span class=style5>용품내역</span></span></td>
            <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
	<tr>
	    <td align=right><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a></td></td>
	<tr> 	
	<%if(!tint.getRent_l_cd().equals("")){%>
    <tr>
      <td class=line2></td>
    </tr>    
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=10%>계약번호</td>
            <td width=15%>&nbsp;<%=rent_l_cd%></td>
            <td class=title width=10%>상호</td>
            <td colspan="3">&nbsp;<%=client.getFirm_nm()%></td>
            <td class=title width=10%>차량구분</td>
            <td colspan="5">&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}%></td>
		  </tr>	
          <tr> 
            <td class=title width=10%>제작사명</td>
            <td width=15%>&nbsp;<%=c_db.getNameById(emp2.getCar_comp_id(),"CAR_COM")%></td>
            <td class=title width=10%>차명</td>
            <td colspan="3">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></td>
            <td class=title width=10%>색상</td>
            <td width=15%>&nbsp;<%=car.getColo()%></td>
		  </tr>	
          <tr> 
            <td class=title width=10%>차대번호</td>
            <td width=15%>&nbsp;<%=pur.getCar_num()%></td>
            <td class=title width=10%>차량번호</td>
            <td width=15%>&nbsp;<%=cr_bean.getCar_no()%></td>
            <td class=title width=10%>임시운행<br>허가번호</td>
            <td width=15%>&nbsp;<%=pur.getTmp_drv_no()%></td>
            <td class=title width=10%>인수지</td>
            <td width=15%>&nbsp;<%if(pur.getUdt_st().equals("1")){%>본사<%}%><%if(pur.getUdt_st().equals("2")){%>지점<%}%><%if(pur.getUdt_st().equals("3")){%>고객<%}%></td>
		  </tr>
          <tr> 
            <td class=title width=10%>출고예정일시</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_EST_DT")))%>&nbsp;<%=String.valueOf(est.get("DLV_EST_H"))%>시</td>
            <td class=title width=10%>인수예정일자</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(pur.getUdt_est_dt())%></td>
            <td class=title width=10%>등록예정일시</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("REG_EST_DT")))%>&nbsp;<%=String.valueOf(est.get("REG_EST_H"))%>시</td>
            <td class=title width=10%>용품에정일시</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("RENT_EST_DT")))%>&nbsp;<%=String.valueOf(est.get("RENT_EST_H"))%>시</td>
		  </tr>
          <tr> 
            <td class=title width=10%>출고일자</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_DT")))%></td>
            <td class=title width=10%>인수일자</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_DT")))%></td>
            <td class=title width=10%>등록일자</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(cr_bean.getInit_reg_dt())%></td>
            <td class=title width=10%>대여개시일</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%></td>
		  </tr>
          <tr> 
            <td class=title width=10%>계출번호</td>
            <td colspan='7'>&nbsp;<%=pur.getRpt_no()%></td>
		  </tr>		  		  		  
		  <%if(base.getUse_yn().equals("N")){%>
          <tr> 
            <td class=title width=10%>해지일자</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(cls.getCls_dt())%></td>
            <td class=title width=10%>해지구분</td>
            <td width=15%>&nbsp;<%=cls.getCls_st()%></td>
            <td class=title width=10%>해지내용</td>
            <td colspan='3'>&nbsp;<%=HtmlUtil.htmlBR(cls.getCls_cau())%></td>
		  </tr>		  
		  <%}%>
		</table>
	  </td>
	</tr>	 
	<tr>
	  <td>&nbsp;</td>
	</tr> 
	<%}%> 
	<%if(!car.getAdd_opt().equals("")){%>		
    <tr>
      <td class=line2></td>
    </tr>    
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=10%>출고후추가장착</td>
            <td>&nbsp;<%=car.getAdd_opt()%>&nbsp;<%=AddUtil.parseDecimal(car.getAdd_opt_amt())%>원</td>
		  </tr>
		</table>
	  </td>
	</tr>	 
	<tr>
	  <td>&nbsp;</td>
	</tr>  		
	<%}%>
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>용품요청내역</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
		  <tr>
		    <td colspan="2" class=title>용품번호</td>
			<td colspan="3">&nbsp;<%=tint.getTint_no()%></td>
		  </tr>
		  <%if(tint.getTint_cau().equals("1")){%>
                <tr>
                    <td colspan="2" class=title>견적반영용품</td>
                    <td colspan="3">&nbsp;
		      <%if(car.getTint_b_yn().equals("Y")){%>2채널 블랙박스<%}%>
                      &nbsp;
                      <%if(car.getTint_s_yn().equals("Y")){%>전면 썬팅
                      &nbsp;
                      가시광선투과율 : <%=car.getTint_s_per()%> %
                      <%}%>        	      
      		      &nbsp;
                      <%if(car.getTint_n_yn().equals("Y")){%>거치형 내비게이션<%}%>
					  </td>
                </tr>					  
		  <%}%>		  
                <tr>
                    <td colspan="2" class=title>제조사용품</td>
                    <td colspan="3">&nbsp;
        			  <%if(pur.getCom_tint().equals("")){%>없음<%}%>
                      <%if(pur.getCom_tint().equals("1")){%>썬팅<%}%>                      
                      <%if(pur.getCom_tint().equals("2")){%>브랜드키트<%}%>
					  </td>
                </tr>						
		  
          <tr> 
            <td colspan="3" class=title>썬팅</td>
            <td colspan="2" class=title>청소용품</td>
          </tr>
          <tr>
            <td width="5%" rowspan="2" class=title>필름</td>
            <td width="5%" class=title>기본</td>
            <td width="40%" >&nbsp;
				<%if(pur.getCom_film_st().equals("")){%>없음<%}%>
                		<%if(pur.getCom_film_st().equals("1")){%>루마<%}%>                      
        			<%if(pur.getCom_film_st().equals("2")){%>모비스<%}%>
				<%if(pur.getCom_film_st().equals("3")){%>SKC<%}%>
				<%if(pur.getCom_film_st().equals("4")){%>3M<%}%>
			</td>
            <td width="10%" rowspan="2" class=title>기본</td>
            <td width="40%" rowspan="2">&nbsp;
			  <select name='cleaner_st' class='default'>
						<option value="1" <%if(tint.getCleaner_st().equals("1")){%>selected<%}%>>있음</option>
						<option value="2" <%if(tint.getCleaner_st().equals("2")){%>selected<%}%>>없음</option>        				
              </select>
			</td>
          </tr>
          <tr>
            <td class=title>선택</td>
            <td width="40%" >&nbsp;
			  <select name='film_st' class='default'>
					    <option value=""  <%if(tint.getFilm_st().equals("")){%>selected<%}%>>없음</option>
						<option value="1" <%if(tint.getFilm_st().equals("1")){%>selected<%}%>>일반</option>
						<option value="2" <%if(tint.getFilm_st().equals("2")){%>selected<%}%>>3M</option>        				
						<option value="3" <%if(tint.getFilm_st().equals("3")){%>selected<%}%>>루마</option>        				
              </select>
		  </td>
          </tr>
          <tr>
            <td colspan="2" class=title>가시광선투과율</td>
            <td>&nbsp;
			  <input type='text' name='sun_per' size='3' <%if(!tint.getTint_no().equals("")){%>value='<%=tint.getSun_per()%>'<%}else{%>value='<%=car.getSun_per()%>'<%}%> class='default' >%
			</td>
            <td class=title>추가</td>
            <td>&nbsp;
                <input type='text' name='cleaner_add' size='45' value='<%=tint.getCleaner_add()%>' class='default' >
            </td>
          </tr>
          <tr> 
            <td colspan="3" class=title>네비게이션</td>
            <td colspan="2" class=title>기타</td>
          </tr>
          <tr>
            <td width="10%" colspan="2" class=title>상품명</td>
            <td>&nbsp;
                <input type='text' name='navi_nm' size='45' value='<%=tint.getNavi_nm()%>' class='default' >
            </td>
            <td colspan="2" rowspan="2">&nbsp;
			  <textarea name="sup_other" cols="57" rows="4" class="default"><%=tint.getOther()%></textarea></td>
          </tr>
          <tr>
            <td colspan="2" class=title>(예상)가격</td>
            <td>&nbsp;
                <input type='text' name='navi_est_amt' maxlength='10' value='<%=AddUtil.parseDecimal(tint.getNavi_est_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                원 </td>
          </tr>
                <tr>
                    <td colspan="2" class=title>블랙박스</td>
                    <td colspan="3">&nbsp;
                                장착여부 : 
        			  <select name='blackbox_yn' class='default'>
						<option value="" <%if(tint.getBlackbox_yn().equals("")){%>selected<%}%>>선택</option>
						<option value="N" <%if(tint.getBlackbox_yn().equals("N")){%>selected<%}%>>미장착</option>
						<option value="Y" <%if(tint.getBlackbox_yn().equals("Y")){%>selected<%}%>>장착</option>      
						<option value="3" <%if(tint.getBlackbox_yn().equals("3")){%>selected<%}%>>배송(광주)</option>        				
						<option value="4" <%if(tint.getBlackbox_yn().equals("4")){%>selected<%}%>>배송(대전)</option>       				
                      </select>
                      &nbsp;&nbsp;제조사/상품명 : 
                      <input type='text' name='blackbox_nm' size='45' value='<%=tint.getBlackbox_nm()%>' class='default' >                      
                      <%if(!tint.getBlackbox_img().equals("")){%>
                          &nbsp;앞:  <a href="javascript:MM_openBrWindow('blackbox/<%= tint.getBlackbox_img() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a>                          
                      <%}%>      
                      <%if(!tint.getBlackbox_img2().equals("")){%>
                          &nbsp;실내:<a href="javascript:MM_openBrWindow('blackbox/<%= tint.getBlackbox_img2() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a>                          
                      <%}%>            
        	    </td>
                </tr>            
          <tr>
            <td colspan="2" class=title>적요</td>
            <td colspan="3">&nbsp;
			  <input type='text' name='sup_etc' size='90' value='<%=tint.getEtc()%>' class='default' >
			</td>
          </tr>
          <tr>
            <td colspan="2" class=title>작업마감<br>요청일시</td>
            <td>&nbsp;
			  <input type='text' size='11' name='sup_est_dt' maxlength='11' class='default' <%if(tint.getSup_est_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint.getSup_est_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
			  <input type='text' size='2' name='sup_est_h' class='default' value=<%if(tint.getSup_est_dt().length()==10){%>'<%=tint.getSup_est_dt().substring(8)%>'<%}%>>시
			</td>
            <td class=title>업체명</td>
            <td>&nbsp;
			  <select name='sup_off_id' class='default'>
                  <option value="">선택</option>
                  <option value="002849다옴방"       <%if(tint.getOff_id().equals("002849"))%>selected<%%>>다옴방</option>
				  <option value="008692주식회사오토카샵" <%if(tint.getOff_id().equals("008692"))%>selected<%%>>주식회사 오토카샵</option>
				  <option value="002850유림카랜드"     <%if(tint.getOff_id().equals("002850"))%>selected<%%>>유림카랜드</option>
				  <option value="002851웰스킨천연가죽" <%if(tint.getOff_id().equals("002851"))%>selected<%%>>웰스킨천연가죽</option>
				   <option value="008501아시아나상사" <%if(tint.getOff_id().equals("008501"))%>selected<%%>>아시아나상사</option>
                </select></td>
          </tr>	
          <tr>
            <td colspan="2" class=title>요청자</td>
            <td colspan="3">&nbsp;
			  <%=c_db.getNameById(tint.getReg_id(),"USER")%>&nbsp;
			  <%=AddUtil.ChangeDate2(tint.getReg_dt())%>
			</td>
          </tr>				  
		</table>
	  </td>
	</tr> 
	<%if(emp2.getCar_comp_id().equals("0001")){%>
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ 현대차 용품지원 : ① 루마썬팅 또는 모비스썬팅 + 극세사먼지떨이 ② 브랜드키트(트렁크정리함+슈즈케이스+에어벤트방향제+세차용걸레+왁스걸레+먼지떨이+멀티담요+세정제)</font> </td>
	</tr>				
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ 제조사용품이 브랜드키트 일때는 아마존카에서 청소용품을 제공하지 않는다.</font> </td>
	</tr>				
	<%}%>
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ 필름 : ① 기본-제조사 지원 ② 선택-아마존카 처리</font> </td>
	</tr>				
	<tr>
	  <td>&nbsp;</td>
	</tr>  	
	<%if(!doc.getUser_dt2().equals("") && doc.getUser_dt3().equals("")){%>
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>요청사항 용품결과</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td width="10%" class=title>작업마감일시</td>
            <td colspan="6">&nbsp;
              <input type='text' size='11' name='sup_dt' maxlength='11' class='default' <%if(tint.getSup_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint.getSup_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
              <input type='text' size='2' name='sup_h' class='default' value=<%if(tint.getSup_dt().length()==10){%>'<%=tint.getSup_dt().substring(8)%>'<%}%>>
            시			
			</td>
          </tr>
          <tr>
            <td rowspan="2" class=title>청구금액</td>
            <td width="15%" class=title>썬팅비</td>
            <td width="15%" class=title >청소용품비</td>
            <td width="15%" class=title>네비게이션</td>
            <td width="15%" class=title>블랙박스</td>
            <td width="15%" class=title >기타</td>
            <td width="15%" class=title>총금액</td>            
          </tr>
          <tr>
            <td align="center" >&nbsp;
              <input type='text' name='tint_amt' maxlength='10' value='<%=AddUtil.parseDecimal(tint.getTint_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt();'>
				원 </td>
            <td align="center" >&nbsp;
              <input type='text' name='cleaner_amt' maxlength='10' value='<%=AddUtil.parseDecimal(tint.getCleaner_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt();'>
				원 </td>
            <td align="center" >&nbsp;
              <input type='text' name='navi_amt' maxlength='10' value='<%=AddUtil.parseDecimal(tint.getNavi_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt();'>
				원 </td>
            <td align="center" >&nbsp;
              <input type='text' name='blackbox_amt' maxlength='10' value='<%=AddUtil.parseDecimal(tint.getBlackbox_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt();'>
				원 </td>				
            <td align="center" >&nbsp;
              <input type='text' name='other_amt' maxlength='10' value='<%=AddUtil.parseDecimal(tint.getOther_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt();'>
				원 </td>
            <td align="center" >&nbsp;
              <input type='text' name='tot_amt' maxlength='10' value='<%=AddUtil.parseDecimal(tint.getTot_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
				원 </td>
          </tr>				  
		</table>
	  </td>
	</tr> 					
	<tr>
	  <td align="right">&nbsp;</td>
	<tr> 
	<%}%>
    <tr>
	  <td align='center'>
	    <%if(!doc.getUser_dt2().equals("") && doc.getUser_dt3().equals("")){%>
	    <a href="javascript:save('settle')" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_js.gif border=0 align=absmiddle></a>
		<%}%>
		&nbsp;&nbsp;&nbsp;
	    <a href="javascript:save('u')" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>				
	  </td>
	</tr>		
  </table>
</form>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

