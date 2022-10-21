<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.bill_mng.*, acar.serv_off.*,acar.car_service.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="so_bean" class="acar.serv_off.ServOffBean" scope="page"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	//정비페이지에서 연결된 경우
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String serv_dt = request.getParameter("serv_dt")==null?"":request.getParameter("serv_dt");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String tot_amt = request.getParameter("tot_amt")==null?"":request.getParameter("tot_amt");
	String serv_st = request.getParameter("serv_st")==null?"":request.getParameter("serv_st");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String buy_user_id = "";
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	String acct_code_s = "";
	String strNm	=	request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	String user_su = request.getParameter("user_su")==null?"1":request.getParameter("user_su");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	ServOffDatabase sod = ServOffDatabase.getInstance();

	//카드 리스트 조회
	//Vector vts = CardDb.getCardUserList(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, user_id, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	//int vt_size = vts.size();
	
	// 추가2006.09.20 부서별 조회
	CodeBean[] depts = c_db.getCodeAll2("0002", "");
	int dept_size = depts.length;
	
	//단기계약 한건 조회-업무지원차량에 대한 정보
	Hashtable res = CardDb.getRentContCase(user_id);
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "10", "06");
	
	//카드정보
	Hashtable ht2 = new Hashtable();
	ht2 = CardDb.getCardUserInfo(user_id);
	/*
	Vector vts2 = CardDb.getCardUserHList2(user_id);
	int vt_size2 = vts2.size();
	if(vt_size2 > 0){
		ht2 = (Hashtable)vts2.elementAt(vt_size2-1);
	}
	*/
	

	
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
	String ven_code = "";
	String ven_name = "";
	//정비업체
	if(!off_id.equals("")){
		so_bean = sod.getServOff(off_id);
		
		ven_code = neoe_db.getVenCode2(AddUtil.replace(so_bean.getEnt_no(),"-",""), AddUtil.replace(so_bean.getEnt_no(),"-",""));//-> neoe_db 변환
	}
	if(!ven_code.equals("")){
		Hashtable vendor = neoe_db.getVendorCase(ven_code);//-> neoe_db 변환
		ven_name = String.valueOf(vendor.get("VEN_NAME"));
	}
	String acct_code = "";
	if(serv_st.equals("2") || serv_st.equals("7"))	acct_code = "00005";
	if(serv_st.equals("4") || serv_st.equals("5"))	acct_code = "00006";
	
	
	String display = "";
	
	String file = "";
	
	//주행거리 가져오기
	CarServDatabase csd = CarServDatabase.getInstance();	
	Hashtable ht9 = csd.getCarInfo(String.valueOf(res.get("CAR_MNG_ID")));
	
	String cardno 		= (String)ht2.get("CARDNO");
	
	String buy_id = "";
	//ht2.get("CARDNO")==null?"":ht2.get("CARDNO");
	//사용할 buy_id 가져오기
	buy_id = CardDb.getCardDocBuyIdNext(cardno);
	//out.println("buy_id="+buy_id+"<br><br>");
	
	//아마존카 정직원 인원수 구하기(20191007)
 	Vector vt_acar = CardDb.getUserSearchList("", "", "AA", "Y");
 	int vt_acar_size = vt_acar.size() + 20;		//	여분 20명
 	if(vt_acar_size%2==1){	vt_acar_size +=	1;		 }	//	홀수이면 짝수가 되게 +1
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery.min.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
 
<script>
$(function() {
  $( "#buy_dt" ).datepicker({
    dateFormat: 'yy-mm-dd',
    prevText: '이전 달',
    nextText: '다음 달',
    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
    dayNames: ['일','월','화','수','목','금','토'],
    dayNamesShort: ['일','월','화','수','목','금','토'],
    dayNamesMin: ['일','월','화','수','목','금','토'],
    showMonthAfterYear: true,
    yearSuffix: '년'
  });
});
</script>
<script language="JavaScript">
<!--

	

	//차량대수에 따른 디스플레이
	function cng_input_carsu(car_su){
		var fm = document.form1;		
		
		var car_su = toInt(car_su) ;
				
		if(car_su >20){
			alert('입력가능한 최대건수는 20건 입니다.');
			return;
		}
				
		<%for(int i=1;i <= 19 ;i++){%>
			if(car_su > <%=i%>){
				tr_acct3_<%=i%>_1.style.display	= '';
				tr_acct3_<%=i%>_3.style.display	= '';
				tr_acct3_<%=i%>_98.style.display	= '';
				
			}else{
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display	= 'none';
			
			}
		<%}%>			
			
	}		
	
	
	//등록
	function Save()
	{
		var fm = document.form1;
		var fm2 = document.form2;
		var auth_rw = fm.auth_rw.value;
	
	//        alert( toInt(parseDigit(fm.oil_liter.value))) ;
	<%-- //	alert(<%=buy_user_id%>); --%>
			
		//날짜가 현재날짜 이후일 수 없다.			
		//if ( toInt(replaceString("-","",fm.buy_dt.value)) > toInt(replaceString("-","",fm.cur_dt.value)) ) {	alert('거래일자를 확인하십시오.'); 	fm.buy_dt.focus(); 		return; }
		
	//	if(parseInt(fm.buy_dt.value.substring(0,4)) == '2012'){ alert('월요일부터 입력 가능합니다.'); return;}		
		
		//입력일 오류가 너무 많아서 일단 추가함.
	<%-- //	if(parseInt(fm.buy_dt.value.substring(0,4)) != <%=AddUtil.getDate(1)%>){ alert('당해년도 전표만 입력 가능합니다.'); return;} --%>		//년도
		<%-- //alert(<%=AddUtil.getDate(5 )%>); --%>
		/*
		if(parseInt(fm.buy_dt.value.substring(0,4)) <= 2014){ 
			if(parseInt(fm.buy_dt.value.substring(5,7)) < 12 ){ 
				alert('전표 일자를 확인 하세요.'); 
				return;
			}
		
		}		
		*/
		
		buy_dt_0 = fm.buy_dt.value;
		buy_dt_1 = buy_dt_0.replace(/-/g, '');
	//	if(auth_rw != '6'){
	//		if(buy_dt_1 > '20161220'){ 
	//			//alert('2016년 12월 21일 이후 전표는 \'New 카드전표관리\' 페이지에서 등록해주세요'); 		
	//			//return;
	//		}
	//	}
		
		if(fm2.cardno.value == '')	{	alert('카드번호를 입력하십시오.'); 	fm2.cardno.focus(); 		return; }
		if(fm.buy_dt.value == '')	{	alert('거래일자를 선택하십시오.'); 	fm.buy_dt.focus(); 		return; }
		if(fm.buy_s_amt.value == '0'){	alert('거래금액을 입력하십시오.'); 	fm.buy_s_amt.focus(); 	return; }
		if(fm.buy_amt.value == '0'){	alert('거래금액을 입력하십시오.'); 	fm.buy_amt.focus(); 	return; }		
		if(fm.ven_name.value == ''){	alert('거래처를 입력하십시오.'); 	fm.ven_name.focus(); 	return; }
		if(fm.buy_v_amt.value != '0' && fm.ven_code.value == ''){	alert('거래처를 조회하십시오?'); return; }

		if ( fm2.cardno.value == '0000-0000-0000-0000' || fm2.cardno.value == '9410-4991-0759-0613'  ) {
		
		} else {
			if(parseInt(fm.buy_dt.value.substring(0,4)) >= '2021'){
				
				//금액이 마이너스 인경우 제외 (일부 취소건 처리)
				if(toInt(parseDigit(fm.buy_amt.value))  < 0){
					
				} else { 
					if(fm2.file.value == ''){	alert('카드전표를 JPG 스캔한 후 등록하십시오.'); 	fm2.file.focus(); 	return; }
				
					//스캔파일 확장자가 ".JPG" 인치 체크 
					
					var file = fm2.file.value;
					file = file.slice(file.indexOf("\\") +1 );
					ext = file.slice(file.indexOf(".")).toLowerCase();
					
					if(ext != '.jpg'){
						alert('JPG가 아닙니다. JPG로 스캔한 파일만 등록이 가능합니다.'); 	
						fm2.file.focus(); 	
						return;
					}
				}
			}
		}
		
		
		if(fm2.user_nm.value == '' || fm2.buy_user_id.value == ''){	alert('사용자를 검색하십시오.'); return; }	
		
		//접대비를 제외한, 과세유형별 부가세 입력 체크
		if(fm.acct_code[1].checked == false ){
			if(fm.ven_st[0].checked == false && fm.ven_st[1].checked == false  && fm.ven_st[2].checked == false  && fm.ven_st[3].checked == false)
				{ alert('과세유형을 선택하십시오.'); return;}
		
			if(fm.ven_st[0].checked == true && fm.buy_v_amt.value == '0' && fm.acct_code_g2[7].checked == false ){	alert('일반과세자입니다. 부가세를 확인해주세요.'); return; }	
			
			if(fm.ven_st[1].checked == true || fm.ven_st[2].checked == true ) {
			   if ( fm.buy_v_amt.value != '0' ) {		  
					alert('간이과세나 면세입니다. 간이과세나 면세는 무조건 부가세를 0으로 입력하세요.'); 
					return;
			   }	
			}
		}
			
		//복리후생비
	if(fm.acct_code.value == '00001' 
			&& fm.acct_code_g[0].checked == false  && fm.acct_code_g[1].checked == false  && fm.acct_code_g[2].checked == false  && fm.acct_code_g[3].checked == false && fm.acct_code_g[4].checked == false
			&& fm.acct_code_g2[0].checked == false && fm.acct_code_g2[1].checked == false && fm.acct_code_g2[2].checked == false 
			&& fm.acct_code_g2[3].checked == false && fm.acct_code_g2[4].checked == false && fm.acct_code_g2[5].checked == false && fm.acct_code_g2[6].checked == false)
			{ alert('구분을 선택하십시오.'); return;}
			
		//복리후생비 - 기타는 임원이상, 이반장님 예외
		if(fm.acct_code[0].checked == true  && fm.acct_code_g[3].checked ==true) {
		   fm.buy_user_id.value  = fm2.buy_user_id.value;
		   if ( fm.buy_user_id.value == "000003" || fm.buy_user_id.value == "000004" || fm.buy_user_id.value == "000005" || fm.buy_user_id.value == "000026"  || fm.buy_user_id.value == "000237" || fm.buy_user_id.value == "000028" ) {
		
		   } else {
		      alert('복리후생비 - 기타로 입력할 수 없습니다!!.');
		      return; 
		   }
		} 
				
		//접대비		
		if(fm.acct_code.value == '00002' 
			//&& fm.acct_code_g[17].checked == false && fm.acct_code_g[18].checked == false && fm.acct_code_g[19].checked == false)
			&& fm.acct_code_g[18].checked == false && fm.acct_code_g[19].checked == false && fm.acct_code_g[20].checked == false)
			{ alert('구분을 선택하십시오.'); return;}
			
		//여비교통비 -제안참석추가 
		if(fm.acct_code.value == '00003' 
			//&& fm.acct_code_g[13].checked == false && fm.acct_code_g[14].checked == false && fm.acct_code_g[15].checked == false  && fm.acct_code_g[16].checked == false )
			&& fm.acct_code_g[14].checked == false && fm.acct_code_g[15].checked == false && fm.acct_code_g[16].checked == false  && fm.acct_code_g[17].checked == false )
			{ alert('구분을 선택하십시오.'); return;}
			
		//차량유류비
		if(fm.acct_code.value == '00004' 
			//&& fm.acct_code_g[5].checked == false  && fm.acct_code_g[6].checked == false  && fm.acct_code_g[7].checked == false
			&& fm.acct_code_g[5].checked == false  && fm.acct_code_g[6].checked == false  && fm.acct_code_g[7].checked == false && fm.acct_code_g[8].checked == false
			&& fm.acct_code_g2[7].checked == false && fm.acct_code_g2[8].checked == false && fm.acct_code_g2[9].checked == false)
			{ alert('구분을 선택하십시오.'); return;}
			
		if(fm.acct_code.value == '00004' ) {
			if ( fm.acct_code_g2[8].checked == true || fm.acct_code_g2[9].checked == true) {
				if ( fm.o_cau.value == '') { alert('사유를 선택하십시오.'); return;}
			}
		}	

		if(fm.acct_code.value == '00004' ) {
			if ( fm.acct_code_g2[7].checked == true) {
				if ( fm.oil_liter.value == '' || fm.oil_liter.value == '0' ||  toInt(parseDigit(fm.oil_liter.value)) == 0   ) { alert('주유량을 입력하십시오.'); return;}
				if ( toInt(parseDigit(fm.oil_liter.value)) > 75   ) { alert('주유량을 다시 한번 확인하시기 바랍니다.'); }
			}
		}
		//주행거리
		if(fm.acct_code.value == '00004' ) {
			if ( fm.acct_code_g2[7].checked == true) {
				if ( fm.tot_dist.value == '' || fm.tot_dist.value == '0' ||  toInt(parseDigit(fm.tot_dist.value)) == 0   ) { alert('주행거리를 입력하십시오.'); return;}
			}
		}
				
		//차량정비비
		if(fm.acct_code.value == '00005'
			//&& fm.acct_code_g[8].checked == false && fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false && fm.acct_code_g[12].checked == false )
			&& fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false && fm.acct_code_g[12].checked == false && fm.acct_code_g[13].checked == false )
			{ alert('구분을 선택하십시오.'); return;}
			
		//사고수리비&사무용품비&소모품비&통신비&도서인쇄비&지급수수료&비품&선급금&교육훈련비
		if ((fm.acct_code.value == '00006' || fm.acct_code.value == '00007' ||  fm.acct_code.value == '00008' ||  fm.acct_code.value == '00009' 
		  || fm.acct_code.value == '00007' ||  fm.acct_code.value == '00010' ||  fm.acct_code.value == '00011' ||  fm.acct_code.value == '00012' ||  fm.acct_code.value == '00013'  )
	//	if((fm.acct_code[5].checked == true || fm.acct_code[6].checked == true || fm.acct_code[7].checked == true || fm.acct_code[8].checked == true
		//		|| fm.acct_code[9].checked == true || fm.acct_code[10].checked == true || fm.acct_code[11].checked == true || fm.acct_code[12].checked == true || fm.acct_code[13].checked == true)
			&& fm.acct_cont[0].value == '')
			{ alert('적요를 입력하십시오.'); return;}
		
		//유류, 정비, 사고, 운반비는 반드시 차량 조회하여 car_mng_id 구한다.
		if(fm.acct_code.value == '00004' || fm.acct_code.value == '00005' ||  fm.acct_code.value == '00006' ||  fm.acct_code.value == '00018' ||  fm.acct_code.value == '00019'  ) {
//		if (fm.acct_code[3].checked == true || fm.acct_code[4].checked == true || fm.acct_code[5].checked == true || fm.acct_code[17].checked == true || fm.acct_code[18].checked == true) {
		   //if (fm.acct_code_g[10].checked == true || fm.acct_code_g[12].checked == true) {
		   if (fm.acct_code_g[11].checked == true || fm.acct_code_g[13].checked == true) {
		   } else {
		   	if ( fm.item_code[0].value == '') { alert('차량을 검색하여 선택하십시오.'); return;}
		   }	
		}
		
		//통신비
		if(fm.acct_code.value == '00009'
			//&& fm.acct_code_g[20].checked == false && fm.acct_code_g[21].checked == false)
			&& fm.acct_code_g[21].checked == false && fm.acct_code_g[22].checked == false)
			{ alert('구분을 선택하십시오.'); return;}
			

		//적요 글자수 체크
		if(fm.acct_cont[0].value != '' && !max_length(fm.acct_cont[0].value,80)){	
			alert('현재 적요 길이는 '+get_length(fm.acct_cont[0].value)+'자(공백포함) 입니다.\n\n적요는 한글40자/영문80자까지 입력이 가능합니다.'); return; } 			

		//전표일자 체크
		if(getRentTime('m', fm.buy_dt.value, <%=AddUtil.getDate()%>) > 3){ 
			if(!confirm('입력하신 전표일자가 석달이상 차이납니다.\n\n전표를 입력 하시겠습니까?'))			
				return;
		}
		
		var sMoney = 0;
		
		var call_nm_cnt =0;
		var call_tel_cnt =0;
		
		//정비비 금액 check - 카드결재액이 정비금액보다 클 수 없음. - 일반정비
		if(fm.acct_code.value == '00005' 	&& fm.acct_code_g[7].checked ==  true) {	
	
			var car_su = toInt(fm.car_su.value);		
		
			for(i=0; i <car_su ; i++){			 				   
			   sMoney += toInt(parseDigit(fm.stot_amt[i].value));	
			    
			    //예비차인 경우  -  카드사용자
			   if(fm.firm_nm[i].value == '(주)아마존카') {
			      fm.call_t_nm[i].value == fm.user_nm.value;   
			      fm.call_t_tel[i].value == '3924242'; 
			   }    
			  
			   if(fm.call_t_nm[i].value == '')   call_nm_cnt+=1;   
			   if(fm.call_t_tel[i].value == '')  call_tel_cnt+=1;  	  
			   
			}	
		
			if ( sMoney < toInt(parseDigit(fm.buy_amt.value))  ) {
			 	  alert('정비금액보다 결재금액이 클 수 없습니다. 확인하세요!!.'); 
			      return;				 
			}
						
			if(call_nm_cnt > 0)	{	alert('차량이용자를 입력하십시오.'); return; }
			if(call_tel_cnt > 0)	{	alert('연락처를 입력하십시오.'); 	return; }		
			
	    }			
	
			
		//if(parseInt(fm.buy_dt.value.substring(0,4)) != <%=AddUtil.getDate(1)%>){ alert('당해년도 전표만 입력 가능합니다.'); return;}		
					
		var inCnt	=	0;
		var strAccCont	=	"";			// 적요
		var strClient	=	"";			// 거래처명
		var strClientNm =	"";			// 거래처 담당자
		var strUserCnt	=	"";			// 식수인원 합
		
		var strDept_id = "";
		var strMoney = "";
		
		var totMoney = 0;
					
		//참가자 리스트
		inCnt = toInt(fm.user_su.value);

		if(inCnt>0){
			for(i=0; i<inCnt ; i++){
				strUserCnt = strUserCnt + fm.user_nm[i+1].value;
				if (inCnt > 1){
					strUserCnt = strUserCnt + ' 등';
					break;
				}
			//	if(i+1 < inCnt)	strUserCnt = strUserCnt + ',';
			}
			//나혼자 선택시 사용자명 직접 넣음.
			if(fm.acct_code_s[0].checked == true){
				strUserCnt = "<%=c_db.getNameById(user_id, "USER")%>";
			}
			
			fm.user_cont.value	=	strUserCnt;		
		}	
			
		    //복리후생비인 경우 부서원 없이 금액 입력 못함. - 식대/ 중식 에 한함
		if(fm.acct_code.value == '00001' ) {		    
  //     if(fm.acct_code[0].checked == true   ){
            if(!fm.acct_code_s.checked == true ){
				if(fm.user_su.value == ''){ alert("인원수를 등록하셔야 합니다. 다시 확인 해주세요"); return; }
				
				if ( toInt(fm.user_su.value) == false ) { alert("인원수는 숫자여야 합니다. 다시 확인 해주세요"); return; }
				
				if(fm.txtTot.value == '' || fm.txtTot.value == '0' ){ alert("금액을 등록하셔야 합니다. 다시 확인 해주세요"); return; }		
					
				if(inCnt>0){
						for(i=0; i<inCnt ; i++){
						   strDept_id =  fm.r_dept_id[i].value;
						   strMoney =  fm.money[i].value;
						   
						   totMoney += toInt(parseDigit(fm.money[i].value));
						   
						   //alert(inCnt);
						   //alert(i);
						   //alert(strDept_id);
						   //alert(strMoney);
						   
							if(fm.acct_code_s[0].checked == true){
								fm.user_su.value = 1;
								fm.user_case_id.value = "<%=user_id%>";
								fm.user_nm.value = "<%=c_db.getNameById(user_id, "USER")%>";
								cng_input1();
							}else{
								if (strDept_id == '' && parseInt(strMoney) > 0 ) {
									alert('사용자를 선택하셔야 금액이 입력 가능합니다!!!.'); 
									return;
								}
							}						   
						}
								
					
						if ( totMoney != toInt(parseDigit(fm.buy_amt.value))  ) {
								  alert('참가인원과 금액을  확인하세요!!.'); 
								  return;				 
						}
					
				}
			}
				strDept_id =  fm.dept_id.value;
				strMoney =  fm.buy_amt.value;
				totMoney += toInt(parseDigit(fm.buy_amt.value));
		}			
					
				
		//개인별 지출금액 합계 점검
		if(fm.txtTot.value != '' && fm.txtTot.value != '0' && fm.txtTot.value != fm.buy_amt.value){ alert("합계와 누계가 맞지 않습니다. 다시 확인 해주세요"); return; }
		
		//정비비, 기타인 경우
		//if(fm.acct_code.value == '00005' && fm.acct_code_g[12].checked == true ){
		if(fm.acct_code.value == '00005' && fm.acct_code_g[13].checked == true ){
		   // 일단 총무팀 승인, 추후 계속 추가
		  if (fm.user_id.value == '000058' || fm.user_id.value == '000070' || fm.user_id.value == '000085'  || fm.user_id.value == '000063' ||   fm.user_id.value == '000029' ||   fm.user_id.value == '000130'  ||   fm.user_id.value == '000128' ||   fm.user_id.value == '000153'||   fm.user_id.value == '000096') {
		  
		  } else {
		 	 alert('정비비 - 기타를 선택할 수 없습니다.!!!');
		 	 return;
		  } 		    
		}
		
		if(fm.acct_code.value == '00001' && fm.acct_code_g[3].checked == true){//복리후생비에서 '기타' 선택시 접대비로 전환되어 부가세 0원으로 바꿔서 저장 
			fm.buy_s_amt.value 		= fm.buy_amt.value;
			fm.buy_v_amt.value 		= 0;
		}
			 
		if(confirm('등록하시겠습니까?')){

			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
			
			file_save();
			fm.action='doc_reg_i_a2.jsp';		
			fm.target='i_no';
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}
		
		
	}

	//대여일수 구하기
	function getRentTime(st, dt1, dt2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//달
		l  = 24*60*60*1000;  		// 1일
		lh = 60*60*1000;  			// 1시간
		lm = 60*1000;  	 	 		// 1분
		var rent_time = "";
		var d1;
		var d2;
		var t1;
		var t2;
		var t3;		
					
		if(dt1 != '' && dt2 != ''){
			d1 = replaceString('-','',dt1)+'00'+ '00';
			d2 = replaceString('-','',dt2)+'00'+ '00';		

			t1 = getDateFromString(d1).getTime();
			t2 = getDateFromString(d2).getTime();
			t3 = t2 - t1;
			
			if(st == 'm') 			rent_time = parseInt(t3/m);
			if(st == 'd') 			rent_time = parseInt(t3/l);			
			
			return rent_time;
			
		}
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}		


	function tot_buy_amt(){
		var fm = document.form1;		
		//접대비가 아니고, 일반과세인 경우
		if(fm.acct_code.value !== '00002' && fm.acct_code.value !== '00004' && fm.ven_st[0].checked == true ) {
					fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
					fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));
		}else{
			fm.buy_s_amt.value 		= fm.buy_amt.value;
			fm.buy_v_amt.value 		= 0;									
		}
		cng_input1();
	}	
	
	//금액셋팅
	function set_buy_amt(){
		var fm = document.form1;	
		fm.buy_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_s_amt.value)) + toInt(parseDigit(fm.buy_v_amt.value)));		
	}
	
	//금액셋팅
	function set_buy_s_amt(){
		var fm = document.form1;	
		fm.buy_s_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_v_amt.value)));				
	}
		
	function set_buy_v_amt(){
		var fm = document.form1;	
		//접대비가 아니고, 일반과세인 경우 fm.acct_code[3].checked == true
		if(fm.acct_code.value !== '00002' && fm.acct_code.value !== '00004' && fm.ven_st[0].checked == true){
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_s_amt.value)) * 0.1 );
		}else{
			fm.buy_v_amt.value = 0;				
		}
		set_buy_amt();			
	}	
	
	//조회---------------------------------------------------------------------------------------------------------------
	
	//네오엠조회-신용카드
	function Neom_search(s_kd){
		var fm2 = document.form2;
		fm2.s_kd.value = s_kd;
		if(s_kd == 'cardno')	fm2.t_wd.value = fm2.cardno_search.value;
		window.open("about:blank",'Neom_cardno_search','scrollbars=yes,status=no,resizable=yes,width=600,height=500,left=350,top=150');		
		fm2.action = "neom_cardno_search.jsp?t_wd="+fm2.t_wd.value;
		fm2.target = "Neom_cardno_search";
		fm2.submit();		
	}
	function Neom_enter(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Neom_search(s_kd);
	}	
	
	//네오엠조회-품목
	function Neom_search2(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == 'item')	fm.t_wd.value = fm.item_name.value;
		window.open("about:blank",'Neom_search2','scrollbars=yes,status=no,resizable=yes,width=600,height=500,left=350,top=150');		
		fm.action = "../card_mng/neom_search.jsp";
		fm.target = "Neom_search2";
		fm.submit();		
	}
	function Neom_enter2(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Neom_search2(s_kd);
	}
	
	//거래처조회하기
	function search(idx){
		var fm = document.form1;	
		var t_wd;
		if(fm.ven_name.value != ''){	fm.t_wd.value = fm.ven_name.value;		}
		else{ 							alert('조회할 거래처명을 입력하십시오.'); 	fm.ven_name.focus(); 	return;}
		window.open("vendor_list.jsp?idx="+idx+"&t_wd="+fm.t_wd.value, "VENDOR_LIST", "left=350, top=150, width=800, height=500, scrollbars=yes");		
	}
	function search_enter(idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') search(idx);
	}	
	
	//장기고객조회하기
	function Rent_search(idx1){
		var fm = document.form1;	
		var t_wd;
		if(fm.buy_dt.value == '')	{	alert('거래일자를 선택하십시오.'); 	fm.buy_dt.focus(); 		return; }
		
		//구분을 선택
		if(fm.acct_code[4].checked == true){ 	//차량정비비
			//if(fm.acct_code_g[8].checked == false && fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false && fm.acct_code_g[12].checked == false  )
			if(fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false && fm.acct_code_g[12].checked == false && fm.acct_code_g[13].checked == false  )
			{	alert('구분을 선택하십시오.'); 	fm.buy_dt.focus(); 		return; }
		}
		
		if(fm.item_name[idx1].value != ''){	fm.t_wd.value = fm.item_name[idx1].value;		}
		else{ 							alert('조회할 차량번호/상호를 입력하십시오.'); 	return;}
		
		if ( fm.acct_code[4].checked == true ) {
			//if (fm.acct_code_g[8].checked 	== true  || fm.acct_code_g[11].checked 	== true ) { //일반정비비, 재리스 정비비
			if (fm.acct_code_g[9].checked 	== true  || fm.acct_code_g[12].checked 	== true ) { //일반정비비, 재리스 정비비
				window.open("service_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value+"&buy_dt="+fm.buy_dt.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			
		    } else {
		    	window.open("rent_search.jsp?t_wd="+fm.t_wd.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			    
		    }
		} else if ( fm.acct_code[5].checked == true ) {
			window.open("service_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value+"&buy_dt="+fm.buy_dt.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			
	    } else {
	    	//window.open("rent_search.jsp?t_wd="+fm.t_wd.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");				    
			window.open("rent_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");		
		}
	}

//추가추가
	//차량이용자조회
	function CarMgr_search(idx1){
		var fm = document.form1;	
		var t_wd;
		if(fm.rent_l_cd[idx1].value != ''){	fm.t_wd.value = fm.rent_l_cd[idx1].value;}
		else{ 							alert('조회할 차량번호를 입력하십시오.');  	return;}
		window.open("s_man.jsp?idx1="+idx1+"&s_kd=3&t_wd="+fm.rent_l_cd[idx1].value, "CarMgr_search", "left=10, top=10, width=600, height=400, scrollbars=yes, status=yes, resizable=yes");				
		
	}

	function Rent_enter(idx1) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Rent_search(idx1);
	}	
		
	//직원조회
	function User_search(nm)
	{
		var fm2 = document.form2;
		var t_wd = fm2.user_nm.value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');		
		fm2.action = "user_search.jsp?nm="+nm+"&t_wd="+t_wd;
		fm2.target = "User_search";
		fm2.submit();		
	}
	
	function enter(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') User_search(nm, idx);
	}	
	
	//직원조회-개별입력
	function User_search2(nm, idx)
	{
		var fm = document.form1;
		if(fm.user_nm[idx].value != '') 	fm.t_wd.value = fm.user_nm[idx].value;
		else								fm.t_wd.value = '';
		window.open("about:blank",'User_search2','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');		
		fm.action = "../card_mng/user_m_search.jsp?dept_id="+fm.dept_id[idx-1].value+"&nm="+nm+"&idx="+idx;
		fm.target = "User_search2";
		fm.submit();		
	}
	function enter2(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') User_search2(nm, idx);
	}	
	
	
	
	//계정과목 안내문
	function help(){
		var fm = document.form1;
		var SUBWIN="help.jsp";	
		window.open(SUBWIN, "help", "left=350, top=350, width=400, height=300, scrollbars=yes, status=yes");
	}
	
	//디스플레이---------------------------------------------------------------------------------------------------------------
	
	function cng_vs_input(){
		var fm = document.form1;
		
		//접대비가 아니고, 일반과세인 경우
		if(fm.acct_code.value !== '00002' && fm.acct_code.value !== '00004' && fm.ven_st[0].checked == true){
			fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));		
		}else{
			fm.buy_s_amt.value 		= fm.buy_amt.value;
			fm.buy_v_amt.value 		= 0;									
		}					
	}
	
	//계정과목 선택시
	function cng_input(val){
		
		var fm = document.form1;
		
		tot_buy_amt();
		
		if(val == '00001'){ 		//복리후생비
			tr_acct1.style.display		= '';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= 'none';
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= 'none';
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= 'none';
			tr_acct3_2.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';
			tr_acct98.style.display		= '';
			tr_acct99.style.display	 	= '';
			tr_acct101.style.display 	= '';	 
			tr_acct_plus.style.display	= 'none';
			fm.acct_code_g[0].checked 	= true;  //식대
			fm.acct_code_g2[1].checked 	= true;
			
			fm.buy_amt.readOnly  = false;
			
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
			
			<%}%>		
			
		}else if(val == '00002'){ 	//접대비			
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= 'none';
			tr_acct6.style.display		= '';
			tr_acct7.style.display		= 'none';
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= 'none';
			tr_acct3_2.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= '';
			tr_acct101.style.display 	= '';	
			
			tr_acct_plus.style.display	= 'none';
			
			fm.buy_amt.readOnly  = false;
			
			//fm.acct_code_g[17].checked 	= true;   //식대
			fm.acct_code_g[18].checked 	= true;   //식대
								
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
			
			<%}%>		
		}else if(val == '00003'){ 	//여비교통비
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= '';
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= 'none';
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= 'none';
			tr_acct3_2.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= '';			
			tr_acct101.style.display 	= '';	
			tr_acct_plus.style.display	= 'none';
			
			fm.buy_amt.readOnly  = false;
			
			//fm.acct_code_g[13].checked 	= true;  //출장비
			fm.acct_code_g[14].checked 	= true;  //출장비
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
		
			<%}%>		
		}else if(val == '00004'){ 	//차량유류대
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= '';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= 'none';
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= 'none';
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= '';
			tr_acct3_2.style.display	= '';
			tr_acct3_3.style.display	= 'none';
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= 'none';
			tr_acct101.style.display 	= 'none';	
			tr_acct_plus.style.display	= 'none';
			fm.buy_amt.readOnly  = false;
			fm.acct_code_g[5].checked 	= true;  //가솔린
			fm.acct_code_g2[7].checked 	= true; //업무
			
					
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';			
			
			<%}%>		
		}else if(val == '00005'){ 	//차량정비비
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= '';
			tr_acct4.style.display		= 'none';			
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= 'none';
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= '';
			tr_acct3_2.style.display	= 'none';		
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= 'none';
			tr_acct101.style.display 	= 'none';	
			
			fm.buy_amt.readOnly  = false;
			
			//fm.acct_code_g[8].checked 	= true;  //일반정비
			fm.acct_code_g[9].checked 	= true;  //일반정비
			
			//if(fm.acct_code_g[8].checked == true){
			if(fm.acct_code_g[9].checked == true){ 
				tr_acct_plus.style.display	= '';
				tr_acct3_3.style.display	= '';
			} else {
				tr_acct_plus.style.display	= 'none';
				tr_acct3_3.style.display	= 'none';
			}			
		
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';			
			
			<%}%>	
			fm.car_su.value = '1';		
		}else if(val == '00006'){ 	//사고수리비
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= 'none';			
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= 'none';
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= '';
			tr_acct3_2.style.display	= 'none';
		
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= 'none';
			tr_acct101.style.display 	= 'none';		
			tr_acct_plus.style.display	= 'none';
			tr_acct_plus.style.display	= '';
			tr_acct3_3.style.display	= ''; 
			
			fm.buy_amt.readOnly  = false;
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
		
			<%}%>	
			fm.car_su.value = '1';	
		}else if(val == '00009'){ 	//통신비
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= 'none';
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= '';
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= 'none';
			tr_acct3_2.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= 'none';			
			tr_acct101.style.display 	= 'none';		
			tr_acct_plus.style.display	= 'none';
			fm.buy_amt.readOnly  = false;
			//fm.acct_code_g[20].checked 	= true;  //개별
			fm.acct_code_g[21].checked 	= true;  //개별
			
			
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
		
			<%}%>		
		}else if(val == '00016' || val == '00017'){ 	//대여사업차량/리스사업차량
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= 'none';
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= 'none';
			tr_acct8.style.display		= '';			
			tr_acct3_1.style.display	= 'none';
			tr_acct3_2.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= 'none';			
			tr_acct101.style.display 	= 'none';		
			tr_acct_plus.style.display	= 'none';
			fm.buy_amt.readOnly  = false;
			//fm.acct_code_g[22].checked 	= true;  //차량등록세
			fm.acct_code_g[23].checked 	= true;  //차량등록세
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
			
			<%}%>
		}else if(val == '00018' ){ 	//운반비
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= 'none';			
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= 'none';
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= '';
			tr_acct3_2.style.display	= 'none';		
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= 'none';
			tr_acct101.style.display 	= 'none';					
			tr_acct_plus.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';		
			fm.buy_amt.readOnly  = false;
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';			
			
			<%}%>	
							
		}else if(val == '00019'){ 	//주차요금			
			
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= 'none';			
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= 'none';
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= '';
			tr_acct3_2.style.display	= 'none';		
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= 'none';
			tr_acct101.style.display 	= 'none';	
			
			fm.buy_amt.readOnly  = false;
			
			//fm.acct_code_g[8].checked 	= true;  //일반정비
			//fm.acct_code_g[9].checked 	= true;  //일반정비
			
			//if(fm.acct_code_g[8].checked == true){
			//if(fm.acct_code_g[9].checked == true){ 
				tr_acct_plus.style.display	= '';
				tr_acct3_3.style.display	= '';
			//} else {
				//tr_acct_plus.style.display	= 'none';
				//tr_acct3_3.style.display	= 'none';
			//}			
		
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';			
			
			<%}%>	
			fm.car_su.value = '1';
		
			<%-- tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= 'none';			
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= 'none';
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= '';
			tr_acct3_2.style.display	= 'none';		
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= 'none';
			tr_acct101.style.display 	= 'none';					
			tr_acct_plus.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';		
			fm.buy_amt.readOnly  = false;
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';			
			
			<%}%> --%>	
		
		}else{
			tr_acct1.style.display		= 'none';
			tr_acct2.style.display		= 'none';
			tr_acct3.style.display		= 'none';
			tr_acct4.style.display		= 'none';
			tr_acct6.style.display		= 'none';
			tr_acct7.style.display		= 'none';
			tr_acct8.style.display		= 'none';			
			tr_acct3_1.style.display	= 'none';
			tr_acct3_2.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';
			tr_acct98.style.display		= '';  //적요
			tr_acct99.style.display		= 'none';
			tr_acct101.style.display 	= 'none';	
			tr_acct_plus.style.display	= 'none';
			fm.buy_amt.readOnly  = false;
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
		
			<%}%>		
		}
	}

	//복리후생비 구분 선택시
	function cng_input2(val)
	{
		var fm = document.form1;
		if(val == '1'){ //식대
			fm.acct_code_g2[1].checked 	= true;
			tr_acct1_1.style.display	= '';
			tr_acct1_2.style.display	= 'none';
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';
			tr_acct101.style.display 	= '';
			
		}
		if(val == '2'){ //회식비
			fm.acct_code_g2[3].checked 	= true;
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= '';			
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';			
			tr_acct101.style.display 	= '';
		
		}
		if(val == '15'){ //경조사
		
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= 'none';			
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';			
			tr_acct101.style.display 	= '';
	
		}
		if(val == '3'){ //기타
	
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= 'none';			
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';			
			tr_acct101.style.display 	= '';	
		}
		if(val == '30'){ //포상휴가
	
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= 'none';			
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';			
			tr_acct101.style.display 	= '';
	
		}
	}	

	//복리후생비 회식비 구분 선택시	
	function cng_input22(val)
	{
		var fm = document.form1;		

		tr_acct98.style.display 	= '';
		tr_acct99.style.display 	= '';					
		tr_acct101.style.display 	= '';	

	}
	
	//통신비 구분 선택시	
	function cng_input7(val)
	{
		var fm = document.form1;		
		if(val == '16'){			//개별			
			tr_acct99.style.display 	= '';					
			tr_acct101.style.display 	= '';			
		}
		if(val == '17'){			//공통
			tr_acct99.style.display 	= 'none';					
			tr_acct101.style.display 	= 'none';	
		
		}
	}
	
	
	//정비비 구분 선택시
	function cng_input4(val)
	{
		var fm = document.form1;
		if(val == '6'){ //일반정비
			tr_acct_plus.style.display	= '';
			tr_acct3_1.style.display	= '';
			tr_acct3_3.style.display	= '';	
				
		}
		if(val == '7'){ //정기검사
			tr_acct_plus.style.display	= 'none';
			tr_acct3_1.style.display	= '';
			tr_acct3_3.style.display	= 'none';
			
		}
	
		if(val == '18'){ //번호판
			tr_acct_plus.style.display	= 'none';
			tr_acct3_1.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';
			
		}
		if(val == '21'){ //재리스정비
			tr_acct_plus.style.display	= 'none';
			tr_acct3_1.style.display	= '';
			tr_acct3_3.style.display	= 'none';
			
		}
		if(val == '22'){ //기타
			tr_acct_plus.style.display	= 'none';
			tr_acct3_1.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';
			
		}
	}
	
	function cng_input11() {
		
		var fm = document.form1.user_Rdio;
		var val = '';
		for(i=0; i<fm.length; i++) {
			if(fm[i].checked == true) 	val=i;
		}
		
		cng_input1();
	}
	
	//개인당 지출 금액(1/n:0, 금액직접입력:1)
	function cng_input1()
	{
		var fm 		= document.form1;
		var inCnt	= toInt(fm.user_su.value);
		var inTot	= toInt(parseDigit(fm.buy_amt.value));
		var innTot	= 0;
		var acar_cnt = fm.acar_cnt.value;

//		if(inCnt > 90){	alert('1/n 입력은 최대 90인까지 입니다.'); return;}
		if(inCnt > acar_cnt){	alert('1/n 입력은 최대 '+acar_cnt+'인까지 입니다.'); return;}
		
		if(fm.user_Rdio[0].checked == true && inCnt > 0 && (toInt(parseDigit(fm.buy_amt.value)) > 0 || toInt(parseDigit(fm.buy_amt.value)) < 0 ))
		{
			var inAmt = Math.round(toInt(parseDigit(fm.buy_amt.value)) / inCnt);			

			for(i=0; i<inCnt ; i++){
				fm.money[i].value = parseDecimal(inAmt);
				innTot += inAmt;
				
				
			}
	//		for(i=inCnt; i<90 ; i++){
			for(i=inCnt; i<acar_cnt; i++){
				fm.money[i].value = '0';
			}
			
			if(inTot > innTot) 	fm.money[0].value 		= parseDecimal(toInt(parseDigit(fm.money[0].value)) 	  + (inTot-innTot));
			if(inTot < innTot) 	fm.money[inCnt-1].value = parseDecimal(toInt(parseDigit(fm.money[inCnt-1].value)) + (inTot-innTot));
			
			fm.txtTot.value = fm.buy_amt.value;
		}
		
		if(fm.user_Rdio[1].checked == true)
		{
	//		for(i=0; i<90 ; i++){
			for(i=0; i<acar_cnt ; i++){
				fm.money[i].value = '0';
			}
			fm.txtTot.value = '0';
		}
	}
	
	function cng_input_vat()
	{
		var fm 		= document.form1;
		var inVat	= toInt(parseDigit(fm.buy_v_amt.value));
		
		if(fm.vat_Rdio[0].checked == true && toInt(parseDigit(fm.buy_v_amt.value)) > 0)
		{
			var inAmt = Math.round(toInt(parseDigit(fm.buy_v_amt.value)) + 1);			
			fm.buy_v_amt.value = parseDecimal(inAmt);
			set_buy_s_amt();	
		}
		if(fm.vat_Rdio[1].checked == true && toInt(parseDigit(fm.buy_v_amt.value)) > 0)
		{
			var inAmt = Math.round(toInt(parseDigit(fm.buy_v_amt.value)) - 1);			
			fm.buy_v_amt.value = parseDecimal(inAmt);
			set_buy_s_amt();	
		}
	}
	
	//직접입력시 합계계산 및 점검
	function Keyvalue()
	{
		var fm 		= document.form1;
		var innTot	= 0;
		var acar_cnt = fm.acar_cnt.value;
		
//		for(i=0; i<90 ; i++){
		for(i=0; i<acar_cnt ; i++){
			innTot += toInt(parseDigit(fm.money[i].value));
		}
		fm.txtTot.value = parseDecimal(innTot);
	}
	
	function date_type_input(date_type){
		var fm = document.form1;
		var today = new Date();
		var s_dt = "";
		var dt = today;
		if(date_type==2){			
			dt = new Date(today.valueOf()-(24*60*60*1000));
		}else if(date_type == 3){
			dt = new Date(today.valueOf()-(24*60*60*1000)*2);			
		}
		s_dt = String(dt.getFullYear())+"-";
		if((dt.getMonth()+1) < 10) 	s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getMonth()+1)+"-";
		if(dt.getDate() < 10) 		s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getDate());
		fm.buy_dt.value = s_dt;		
	}	
	
	
	//직원조회-
	function User_search3(nm, idx)
	{
		var fm = document.form1;
		if(fm.user_nm[idx].value != '') 	fm.t_wd.value = fm.user_nm[idx].value;
		else								fm.t_wd.value = '';
		window.open("about:blank",'User_search3','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');		
		fm.action = "../card_mng/user_m_search2.jsp?dept_id="+fm.dept_id[idx-1].value+"&nm="+nm+"&idx="+idx;
		fm.target = "User_search3";
		fm.submit();		
	}
	function enter3(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') User_search3(nm, idx);
	}

	function cng_input5(val)
	{
		var fm = document.form1;
		if(val == '1'){ //나혼자
			fm.user_su.value = 1;
			fm.user_case_id.value = "<%=buy_user_id%>";
			fm.user_nm.value = "<%=c_db.getNameById(buy_user_id, "USER")%>";
			tr_acct101.style.display 	= 'none';
			cng_input11();
		}
		if(val == '2'){ //파트너
		//	fm.user_su.value = "";
			tr_acct101.style.display 	= '';
			var idx = "1";
			var nm = "user_case_id";
			var dept_id = "PPPP";
			window.open("about:blank",'User_Group','scrollbars=yes,status=no,resizable=yes,width=300,height=400,left=370,top=200');		
			fm.action = "../card_mng/user_m_search2.jsp?dept_id="+dept_id+"&nm="+nm+"&idx="+idx;
			fm.target = "User_Group";
			fm.submit();
						
		}
		if(val == '3'){ //선택
			fm.user_su.value = "";
			tr_acct101.style.display 	= '';
		}
	}

	function cng_input3(){
	
		var fm = document.form1;
		
		if(fm.acct_code_g2[7].checked == true){ //업무		
			fm.item_name[0].value = "<%=res.get("CAR_NO")%>";
			fm.acct_cont[0].value = "<%="(주)아마존카 - "+res.get("CAR_NO")%>";
			fm.item_code[0].value = "<%=res.get("CAR_MNG_ID")%>";
			fm.rent_l_cd[0].value = "<%=res.get("RENT_L_CD")%>";
			fm.last_dist.value = "<%=ht9.get("TOT_DIST")%>";
			fm.last_serv_dt.value = "<%=AddUtil.ChangeDate2((String)ht9.get("SERV_DT"))%>";
			
			fm.buy_amt.readOnly  = true;
		//	Rent_search(0);
		}else{
			fm.item_name[0].value = "";
			fm.acct_cont[0].value = "";
			fm.item_code[0].value = "";
			fm.rent_l_cd[0].value = "";
			
			fm.buy_amt.readOnly  = false;
		}
	}
	
	//국세청과세유형조회
	function search_nts(){
		var fm = document.form1;
		fm.nts_yn.value='Y';
		window.open("https://teht.hometax.go.kr/websquare/websquare.html?w2xPath=/ui/ab/a/a/UTEABAAA13.xml", "NTS_SEARCH", "left=0, top=0, height=<%=s_height%>, width=<%=s_width%>, scrollbars=yes");
	}	
	



	//거래일자 증가/감소 버튼
	var buy_dt = new Date();

	
	function getTodate(){
	

		var toYear = buy_dt.getFullYear();
		var toMonth = buy_dt.getMonth() + 1;

		if(toMonth < 10)	toMonth = "0"+toMonth;

		var toDay = buy_dt.getDate();

		if(toDay < 10)	toDay = "0"+toDay;

		document.form1.buy_dt.value = toYear + "-" + toMonth + "-" + toDay;

	}

	function getAddDay(addend) {
		var fm = document.form1;
		var ymd = fm.buy_dt.value;
		
//		alert(ymd);
		var toYear = buy_dt.getFullYear();
		var toMonth = buy_dt.getMonth();
		// 일자를 원하는 더해준다
		var toDay = buy_dt.getDate() + addend;

		buy_dt = new Date(toYear,toMonth,toDay);
		
		getTodate();
	}


	function file_save(){
		var fm2 = document.form2;	
		
		fm2.<%=Webconst.Common.contentSeqName %>.value = fm2.cardno.value+''+fm2.buy_id.value;
				
	//	if(!confirm('파일등록하시겠습니까?')){			return;		}

		fm2.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact_t.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.CARD_DOC%>";
		fm2.submit();
		
	}
	
	//javascript:document.form2.cardno_search.focus();codument.form1.
	

//-->
</script>

</head>
<body onLoad="javascript:document.form2.cardno_search.focus(); tr_acct101.style.display 	= '';">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 법인전표관리 > <span class=style5>카드전표등록 New</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
<form action="" name="form2" method="POST" enctype="multipart/form-data">
	<input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
	<input type='hidden' name="user_id" 		value="<%=user_id%>">
	<input type="hidden" name="etc" value="">    
	<input type="hidden" name="buy_id" value="<%=buy_id%>">
	<input type="hidden" name="s_kd" value="">
	<input type="hidden" name="t_wd" value="">
	 
<table border="0" cellspacing="1" cellpadding="0" width='100%'>
	<tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>카드정보</span></td>
    </tr>
	<tr><td class=line2 colspan=2></td></tr>
    <tr> 
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr> 
            		<td width='10%'  class='title'>카드 조회</td>
            		<td colspan="3">&nbsp; 
            			<input name="cardno_search" type="text" class="text" value="" size="30" style='IME-MODE: active' onKeyDown="javasript:Neom_enter('cardno')" >
              			&nbsp;<a href="javascript:Neom_search('cardno');" ><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
						&nbsp;<span style="font-size:8pt">(카드번호/사용자명으로 검색)</span>
            		</td>
          		</tr>
          
          		<tr> 
            		<td width='10%'  class='title'>신용카드번호</td>
            		<td width="50%" >&nbsp; <input name="cardno" type="text" class="whitetext"  value="<%=ht2.get("CARDNO")==null?"":ht2.get("CARDNO")%>" size="30"  ></td>
            		<td width="10%" class='title'>사용자구분</td>
            		<td>&nbsp; <input name="card_name" type="text" class="whitetext" value="<%=ht2.get("CARD_NAME")==null?"":ht2.get("CARD_NAME")%>" size="30" redeonly></td>
          		</tr>
          		
          		<tr> 
            		<td class='title'>발급일자</td>
            		<td>&nbsp; <input name="card_sdate" type="text" class="whitetext" value="<%=AddUtil.ChangeDate3(String.valueOf(ht2.get("USE_S_DT")))%>" size="15" redeonly></td>
            		<td class='title'>만기일자</td>
            		<td>&nbsp; <input name="card_edate" type="text" class="whitetext" value="<%=AddUtil.ChangeDate3(String.valueOf(ht2.get("USE_E_DT")))%>" size="15" redeonly></td>
          		</tr>
          
          		<tr> 
		            <td class='title'>사용자</td>
		            <td colspan="3">&nbsp; 
			        	<input name="user_nm" type="text" class="text"  value="<%=c_db.getNameById(user_id, "USER")%>" size="12" style='IME-MODE: active' onKeyDown="javasript:enter('buy_user_id')"> 
						<input type="hidden" name="buy_id2" value="">
			            <input type="hidden" name="buy_user_id" value="<%=user_id%>">
			            <a href="javascript:User_search('buy_user_id');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
		            </td>
          		</tr>
          		
        	</table>
        </td>
    </tr>   
    <tr>
    	<td class=h></td>
    </tr>
	
	<tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>첨부파일</span></td>
    </tr>
	<tr>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="10%" class='title'>영수증스캔파일</td>
          			<td width="90%">&nbsp;
						<input type='file' name="file" size='40' class='text'>
						<input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=cardno%><%=buy_id%>' />
						<input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.CARD_DOC%>' />
            		</td>
        		</tr>
      		</table>
      	</td>
    </tr>
	<tr>
		<td class=h></td>
	</tr>
</table>
</form>
<form action="" name="form1" method="POST">
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">     
<input type='hidden' name="sh_height" value="<%=sh_height%>">   
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>    
<input type='hidden' name="idx" value="<%=idx%>">
<input type="hidden" name="type" value="search">  
<input type="hidden" name="s_kd" value="">
<input type="hidden" name="t_wd" value="">  

<input type='hidden' name="buy_id" 		value="<%=buy_id%>">
<input type="hidden" name="cardno" value="<%=ht2.get("CARDNO")==null?"":ht2.get("CARDNO")%>">  
<input type="hidden" name="card_name" value="<%=ht2.get("CARD_NAME")==null?"":ht2.get("CARD_NAME")%>">  
<input type="hidden" name="buy_user_id" value="<%=buy_user_id%>">  
<input type="hidden" name="user_nm" value="<%=c_db.getNameById(user_id, "USER")%>">  
<input type="hidden" name="cardno_search" value="">  


<input type="hidden" name="cur_dt" value="<%=AddUtil.getDate()%>">  
<input type='hidden' name='nts_yn' value=''>
<input type="hidden" name="acar_cnt" value="<%=vt_acar_size%>"> 

<!-- 첫번째 테이블 //-->
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>카드전표등록</span></td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr>
    	<td colspan="2" class=line>
	    	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
          		<tr>
            		<td colspan="2" class='title'>거래일자</td>
          			<td colspan="3">&nbsp;
					<!--<input size="12" id="buy_dt" type="text" READONLY name="buy_dt" class="text" title="YYYY-MM-DD" onClick="displayCalendar(this);" value="<%=AddUtil.getDate()%>">-->
					<input class="date-picker" type="text" value="<%//=AddUtil.getDate()%>" id="buy_dt" type="text" READONLY name="buy_dt" title="YYYY-MM-DD" size="12"/> ※날짜를 선택하면 달력이 표시되어 원하는 날짜를 선택할 수 있습니다.
		  	  			<!--<input name="buy_dt" id="buy_dt" type="text" class="text" value="<%=serv_dt%>" size="12" onBlur='javascript:this.value=ChangeDate2(this.value)'>
						&nbsp;&nbsp;
					    <input type='radio' name="date_type" value='1'  onClick="javascript:date_type_input(1)">오늘
						<input type='radio' name="date_type" value='2'  onClick="javascript:date_type_input(2)">어제
						<input type='radio' name="date_type" value='3'  onClick="javascript:date_type_input(3)">그제	
						<%//if(user_id.equals("000096")){%>
						&nbsp;&nbsp;&nbsp;<input type="button" value="일자증가" onclick="javascript:getAddDay(1);">&nbsp;<input type="button" value="일자감소" onclick="javascript:getAddDay(-1);">
						<%//}%>
						-->
		  	  		</td>
          		</tr>
          		<tr>
          			<td colspan="2" class='title'>거래처</td>
          			<td width=50% >&nbsp;
		            	<input name="ven_name" type="text" class="text" value="<%=ven_name%>" size="35" style='IME-MODE: active' onKeyDown="javasript:search_enter(1)">
						<input type="hidden" name="ven_code" value="<%=ven_code%>">
						<a href="javascript:search(1);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a> 
						<span style="font-size:8pt">(카드 가맹점, <b>사업자등록번호</b>로 검색)</span>
					</td>
					<td width=10% class='title' style="font-size:8pt">사업자등록번호</td>
					<td>&nbsp;
		            	<input type="text" class="whitetext"   name="ven_nm_cd"  value="">&nbsp;						
					</td>
       	  		</tr>
          		<tr>
          			<td colspan="2" class='title'>과세유형</td>
          			<td colspan="3" >&nbsp;
          			<input type="hidden" name="ve_st" value="">
          			              <input type="radio" name="ven_st" value="1"  onClick="javascript:cng_vs_input()">일반과세
					&nbsp;<input type="radio" name="ven_st" value="2"  onClick="javascript:cng_vs_input()">간이과세
					&nbsp;<input type="radio" name="ven_st" value="3"  onClick="javascript:cng_vs_input()">면세
					&nbsp;<input type="radio" name="ven_st" value="4"  onClick="javascript:cng_vs_input()">비영리법인(국가기관/단체)
					&nbsp;&nbsp;
					<!--<a href="http://www.nts.go.kr/front/reference/Saup/refer_saupja.asp" target="_blank">[국세청 사업자 과세유형 조회]</a>-->
					<!--<a href="http://www.nts.go.kr/cal/cal_02.asp" target="_blank"><img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0></a>-->
					<!--<a href="http://www.nts.go.kr/cal/cal_check_02.asp" target="_blank"><img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0></a>-->
					<a href="javascript:search_nts();"><img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0></a>
					&nbsp;<input type="text" class="whitetext"   name="nts_search_nm"  value="">
				</td>
       	  		</tr>		            
          		<tr>
          			<td colspan="2" class='title'>세금계산서</td>
          			<td colspan="3" >&nbsp;<input type="checkbox" name="tax_yn" value="Y"> (과세매입- 카드전표와 별도로 세금계산서가 발행된 경우에 체크, 네오엠 회계처리상 필요)</td>
       	  		</tr>	
       	  			  				
          		<tr>
          			<td width="3%" rowspan="3" class='title'>거<br>래<br>금<br>액</td>
          			<td class='title'>공급가</td>
          			<td colspan="3" >&nbsp;
              			<input type="text" name="buy_s_amt" value="" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_buy_v_amt();'>원
						
            		</td>
          		</tr>
          
          		<tr>
          			<td class='title'>부가세</td>
          			<td colspan="3" >&nbsp;
              			<input type="text" name="buy_v_amt" value="" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_buy_amt();'>원
						&nbsp;&nbsp;<font color="red">※ 카드전표는 모두 부가세 환급대상입니다.(접대비 제외)</font>
            		</td>
            	</tr>          
          		<tr>
          			<td width="7%" class='title'>합계</td>
          			<td  colspan="3" >&nbsp;
              			<input type="text" name="buy_amt" value="<%=tot_amt%>" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); tot_buy_amt();'>원
              			&nbsp;&nbsp;<font color="blue">※ 부가세 끝전조정 <input type="radio" name="vat_Rdio" value="0" onClick="javascript:cng_input_vat()" > 상향
			      		<input type="radio" name="vat_Rdio" value="1" onClick="javascript:cng_input_vat()">하향 &nbsp;</font>
              		</td>
          		</tr>
          		          
          		<tr>
          			<td colspan="2" class='title'>계정과목</td>
          			<td  colspan="3" >
			  			<table width="100%" border="0">
			    			<tr>
			  					<td>&nbsp;
				  					<select name="acct_code" onchange="javascript:cng_input(this.options[this.selectedIndex].value); cng_input3();">
					  					<optgroup label="직원">
							  				<option value="00001">복리후생비</option>
							  				<option value="00002">접대비</option>
							  				<option value="00003">여비교통비</option>
							  				<option value="00004">차량유류대</option>
							  				<option value="00005">차량정비비</option>
							  				<option value="00006">사고수리비</option>
							  				<option value="00007">사무용품비</option>
							  				<option value="00009">통신비</option>
						  				</optgroup>
						  				<optgroup label="공통">
						  					<option value="00008">소모품비</option>
						  					<option value="00010">도서인쇄비</option>
						  					<option value="00011">지급수수료</option>
						  					<option value="00012">비품</option>
						  					<option value="00013">선급금</option>
						  					<option value="00014">교육훈련비</option>
						  					<option value="00015">세금과공과</option>
						  					<option value="00016">대여사업차량</option>
						  					<option value="00017">리스사업차량</option>
						  					<option value="00018">운반비</option>
						  					<option value="00019">주차요금</option>
						  					<option value="00021">업무비선급금</option>
						  				</optgroup>					  				
						  			</select>
					  			</td>
								<td colspan=2>&nbsp;</td>				  
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
    <tr>
    	<td class=h></td>
    </tr>  
    
    <tr>
        <td colspan="2" ><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사용내역</span>              
        </td>      
    </tr>
    
    <tr><td class=line2 colspan=2></td></tr>
    <tr id=tr_acct1 style="display:''">
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="10%" rowspan="2" class='title'>구분</td>
          			<td width="90%">&nbsp;
		      			<input type="radio" name="acct_code_g" value="1" checked onClick="javascript:cng_input2(this.value)">식대
              			<input type="radio" name="acct_code_g" value="2" onClick="javascript:cng_input2(this.value)">회식비
			  			<input type="radio" name="acct_code_g" value="15" onClick="javascript:cng_input2(this.value)">경조사
			  			<input type="radio" name="acct_code_g" value="3" onClick="javascript:cng_input2(this.value); cng_vs_input()">기타
			  			<input type="radio" name="acct_code_g" value="30" disabled  onClick="javascript:cng_input2(this.value)">포상휴가
			  	
		  			</td>
		  		</tr>
        		
        		<tr>
          			<td>
          				<table width="90%"  border="0" cellpadding="0" cellspacing="0">
              				<tr id=tr_acct1_1 style="display:''">
                				<td>&nbsp;
                  					<input type="radio" name="acct_code_g2" value="1" >조식
				  					<input type="radio" name="acct_code_g2" value="2" checked>중식
				  					<input type="radio" name="acct_code_g2" value="3" >특근식
				  				</td>
              				</tr>
              				
              				<tr id=tr_acct1_2 style='display:none'>
                				<td>&nbsp;
				  					<input type="radio" name="acct_code_g2" value="15" onClick="javascript:cng_input22(this.value);">사내동호회 
                  					<input type="radio" name="acct_code_g2" value="4" onClick="javascript:cng_input22(this.value);">회사전체모임
				  					<input type="radio" name="acct_code_g2" value="5" onClick="javascript:cng_input22(this.value);">부서별 정기모임
				  					<input type="radio" name="acct_code_g2" value="6" onClick="javascript:cng_input22(this.value);">부서별 부정기회식
				  				</td>
              				</tr>
           				</table>
           			</td>
        		</tr>
       		</table>
       	</td>
    </tr>
    
    <tr id=tr_acct2 style='display:none'>
    	<td colspan="2" class="line">
      		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="10%" rowspan="2" class='title' >구분</td>
          			<td width="10%" class='title'>유종</td>
          		
          			<td width="80%">&nbsp;
          				<input type="radio" name="acct_code_g" value="13">가솔린
						<input type="radio" name="acct_code_g" value="4">디젤
						<input type="radio" name="acct_code_g" value="5">LPG
						<input type="radio" name="acct_code_g" value="27">전기/수소	<!-- 전기차충전 추가 -->
			  		</td>
				</tr>
				
				<tr>
					<td width="10%" class='title'>용도</td>
					<td width="90%">&nbsp;
						<input type="radio" name="acct_code_g2" value="11" onClick="javascript:cng_input3(this.value)">업무
						<input type="radio" name="acct_code_g2" value="12" onClick="javascript:cng_input3(this.value)">예비차 보충
						<input type="radio" name="acct_code_g2" value="13" onClick="javascript:cng_input3(this.value)">고객차량
					</td>
				</tr>
			</table>
      	</td>
    </tr>
    
    <tr id=tr_acct3 style='display:none'>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
	        	<tr>
	          		<td width="10%" class='title'>구분</td>
	          		<td>&nbsp;
	          			<input type="radio" name="acct_code_g" value="6"  onClick="javascript:cng_input4(this.value);">일반정비
						<input type="radio" name="acct_code_g" value="7"  onclick="javascript:cng_input4(this.value);">자동차검사
				<!--	<input type="radio" name="acct_code_g" value="8"  onclick="javascript:cng_input4(this.value);">점검기록부  -->
						<input type="radio" name="acct_code_g" value="18" onclick="javascript:cng_input4(this.value);">번호판대금	
						<input type="radio" name="acct_code_g" value="21" onclick="javascript:cng_input4(this.value);">재리스정비	
						<input type="radio" name="acct_code_g" value="22" onclick="javascript:cng_input4(this.value);">기타						
					</td>
	        	</tr>
      		</table>
      	</td>
    </tr>
      	
    <tr id=tr_acct4 style='display:none'>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="10%" class='title'>구분</td>
          			<td>&nbsp;
            			<input type="radio" name="acct_code_g" value="9">출장비
						<input type="radio" name="acct_code_g" value="10">기타교통비
						<input type="radio" name="acct_code_g" value="20">하이패스
						<input type="radio" name="acct_code_g" value="32">제안참석
					</td>
        		</tr>
      		</table>
      	</td>
    </tr>
    
    <tr id=tr_acct6 style='display:none'>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="10%" class='title'>구분</td>
          			<td>&nbsp;
            			<input type="radio" name="acct_code_g" value="11">식대
						<input type="radio" name="acct_code_g" value="12">경조사
						<input type="radio" name="acct_code_g" value="14">기타
					</td>
        		</tr>
      		</table>
      	</td>
    </tr>
          	
    <tr id=tr_acct7 style='display:none'>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="10%" class='title'>구분</td>
          			<td>&nbsp;
            			<input type="radio" name="acct_code_g" value="16" onClick="javascript:cng_input7(this.value);">개별
						<input type="radio" name="acct_code_g" value="17" onClick="javascript:cng_input7(this.value);">공통
					</td>
        		</tr>
      		</table>
      	</td>
    </tr>
    
    <tr id=tr_acct8 style='display:none'>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="10%" class='title'>구분</td>
          			<td>&nbsp;
            			<input type="radio" name="acct_code_g" value="19">차량등록세
						<input type="radio" name="acct_code_g" value="23">차량취득세
						<input type="radio" name="acct_code_g" value="24">차량자동차세
						<input type="radio" name="acct_code_g" value="25">차량환경개선부담금
						<input type="radio" name="acct_code_g" value="26">차량개별소비세
					</td>
        		</tr>
      		</table>
      	</td>
    </tr>

  <tr id=tr_acct_plus style='display:none'>
    	<td colspan="2" >
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="10%" ></td>
          			<td align=right>&nbsp;입력 대수 : <input type="text" name="car_su" value="1" size="2" class="text" onBlur='javscript:cng_input_carsu(this.value);'>&nbsp;&nbsp;&nbsp;건
          			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=red>* 입력 대수는 20대까지 가능합니다.</font></td> 
        		</tr>
      		</table>
      	</td>
  </tr>								

  <tr id=tr_acct3_1 style='display:none'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="10%" class='title'>차량</td>
          <td width="50%">&nbsp;
            <input name="item_name" type="text" class="text" value="" size="50" style='IME-MODE: active' onKeyDown="javasript:Rent_enter('0')">
			<input type="hidden" name="rent_l_cd" value="">
			<input type="hidden" name="serv_id" value="">
			<input type="hidden" name="item_code" value="">
			<input type="hidden" name="stot_amt" value="">
			<input type="hidden" name="firm_nm" value="">
            <a href="javascript:Rent_search('0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
              &nbsp;(차량번호/상호로 검색)</td>
			   <td width="10%" class='title'>최종주행거리</td>
			<td width="10%" align="center"><input type="text" name="last_dist" value="" size="10" class=num>km&nbsp;</td>
			<td width="8%" class='title'>등록일</td>
			<td width="12%" align="center"><input type="text" name="last_serv_dt" value="" size="10">&nbsp;</td>
        </tr>
     		
      </table></td>
    </tr>
    
    <tr id=tr_acct3_2 style='display:none'>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>  
        		<tr>
		          <td width="10%" class='title'>사유</td>
		          <td width="29%">&nbsp;
		          			<select name="o_cau" >
		        			    <option value="">--선택--</option>
		        				<%for(int i = 0 ; i < c_size ; i++){
		        					CodeBean code = codes[i];	%>
		        				<option value='<%=code.getNm_cd()%>'><%= code.getNm()%></option>
		        				<%}%>
		          			</select>
		            &nbsp;*업무용인 경우 선택안해도 됨.
		          </td>
		          <td width="8%" class='title'>주유량</td>
		          <td width="35%">&nbsp;
		          	<input type='text' size='7' class='num'  name='oil_liter' >&nbsp;L		
		            &nbsp;*업무용인 경우 필수(소숫점세자리까지 입력가능)		          	
		          </td>
				  <td width="8%" class='title'>실주행거리</td>
		          <td width="10%">&nbsp;
		          	<input type='text' size='10' class='num'  name='tot_dist' >&nbsp;km		
		          </td>
		        </tr>
    
      		</table>
      	</td>
    </tr>
    
    <tr id=tr_acct3_3 style='display:none'>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
		          <td width="10%" class='title'>차량이용자</td>
		          <td width="40%">&nbsp;
		       		   <input type='text' size='30' class='text'  name='call_t_nm' >		                
		          </td>
		         <td width="10%" class='title'>연락처</td>
		         <td width="40%">&nbsp;
		         	<input type='text' size='30' class='text'  name='call_t_tel' >
							<a href="javascript:CarMgr_search('0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
		          </td>
		        </tr>
		           
    
      		</table>
      	</td>
    </tr>
    
    <tr id=tr_acct98 style="display:''">
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
          			<td width="10%" class='title'>적요</td>
          			<td width="90%">&nbsp;
            			<textarea name="acct_cont" cols="100" rows="2" class="text"></textarea> (한글40자이내)
            		</td>
        		</tr>
      		</table>
      	</td>
    </tr>
    
    <tr>
    	<td class=h></td>
    </tr>
    
  <%for(int j=1; j<= 19; j++){
  	%>
     <tr id=tr_acct3_<%=j%>_1 style='display:none'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="10%" class='title'>차량</td>
          <td width="90%">&nbsp;
            <input name="item_name" type="text" class="text" value="" size="50" style='IME-MODE: active' onKeyDown="javasript:Rent_enter('<%=j%>')">
				<input type="hidden" name="rent_l_cd" value="">
				<input type="hidden" name="serv_id" value="">
				<input type="hidden" name="item_code" value="">
				<input type="hidden" name="stot_amt" value="">
				<input type="hidden" name="firm_nm" value="">
            <a href="javascript:Rent_search('<%=j%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
              &nbsp;(차량번호/상호로 검색)</td>
        </tr>
     		
      </table></td>
    </tr>     
    
     <tr id=tr_acct3_<%=j%>_3 style='display:none'>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
		          <td width="10%" class='title'>차량이용자</td>
		          <td width="30%">&nbsp;
		       		   <input type='text' size='30' class='text'  name='call_t_nm' >		                
		          </td>
		         <td width="10%" class='title'>연락처</td>
		         <td width="50%">&nbsp;
		         	<input type='text' size='30' class='text'  name='call_t_tel' >		           
							<a href="javascript:CarMgr_search('<%=j%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
		          </td>
		        </tr>
		             
    
      		</table>
      	</td>
    </tr>      
   
    <tr id=tr_acct3_<%=j%>_98 style='display:none'>
    	<td colspan="2" >
    		<table border="0" cellspacing="0" cellpadding="0" width='100%'>
        		<tr>
        			<td class="line">
	        			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        			<tr>
			          			<td width="10%" class='title'>적요</td>
			          			<td width="90%">&nbsp;
			            			<textarea name="acct_cont" cols="100" rows="2" class="text"></textarea> (한글40자이내)
			            		</td>
			            	</tr>
			            </table>
			        </td>    		
        		</tr>
		        <tr>
		        <td colspan=2 class=h>&nbsp;</td> 
		        </tr>	 
    
      		</table>
      	</td>
    </tr>
              
<% } %>
	
    <tr>
    	<td class=h></td>
    </tr>
    <tr id=tr_acct99 style="display:''">
    	<td colspan="2" class="line">
      		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td colspan='4'><font color="red">※ "혼자" 선택시 카드사용자가 아닌 등록하는 사람으로 입력됩니다. 다른직원의 전표를 대신 등록하고자 할때는 "선택"을 체크하여 입력하시기 바랍니다.</font></td>
				</tr>
        		<tr>
          			<td width="10%" class='title'>비용분담</td>                                                                                                                                                                                                          
          			<td width="25%" align='center'>&nbsp;
						<input type='radio' name="acct_code_s" value='1' onClick="javascript:cng_input5(this.value)" checked >혼자&nbsp;&nbsp;&nbsp;
						<input type='radio' name="acct_code_s" value='2' onClick="javascript:cng_input5(this.value)" >파트너&nbsp;&nbsp;&nbsp;
						<input type='radio' name="acct_code_s" value='3' onClick="javascript:cng_input5(this.value)" >선택&nbsp;&nbsp;&nbsp;
            			<input name="user_su" type="text" class="text" value ="<%=user_su%>" size="3" onBlur="javascript:cng_input11();">명       		  
            			<input name="user_cont" type="hidden" class="text"  value="" size="10">
					</td>
					
          			<td width="15%" class='title'>개인별 지출금액</td>
              	
              		<td width="50%">	
			     		<input type="radio" name="user_Rdio" value="0" onClick="javascript:cng_input1()" checked> 1/n
			      		<input type="radio" name="user_Rdio" value="1" onClick="javascript:cng_input1()">금액 직접입력 &nbsp;
			      		<input type="hidden"  name="buy_a_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
					</td>
          		</tr>
          	</table>
        </td>
    </tr>
    <tr>
    	<td class=h></td>
    </tr>
    <tr>
    	<td class=h></td>
    </tr>
     
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>부서/성명/금액 입력</span></td>
        <td align="right">
            <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
      		<a id="submitLink" href="javascript:Save()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
      	    <%}%>	
      	</td>
    </tr>
    
  	<tr>
		<td id=tr_acct101 style="display:''" colspan="2">
			<table border="0" cellspacing=0 cellpadding=0 width="100%">
			    <tr><td class=line2></td></tr>
				<tr>
					<td class=line>
						<table width="100%" border="0" cellspacing="1" cellpadding="0">
                        	<tr>
	                         	<td width="7%" class='title'>연번</td>
	                         	<td width="15%" class='title'>부서</td>
								<td width="15%" class='title'>성명</td>
							 	<td width="13%" class='title'>금액</td>
								<td width="7%" class='title'>연번</td>
	                         	<td width="15%" class='title'>부서</td>
								<td width="15%" class='title'>성명</td>
							 	<td width="13%" class='title'>금액</td>
                        	</tr>
              <%-- <%for(int j = 0 ; j < 90 ; j+=2 ){%> --%>
                        <%for(int j = 0 ; j < vt_acar_size; j+=2 ){%>
                        	<tr>
	                         	<td align="center"><%=j+1%></td>
								<td align="center">
									<select name='dept_id' onChange="javascript:User_search2('user_case_id',<%=j+1%>);">>	
          								<option value=''>선택</option>
          								<option value='AAAA'>전체</option>
          								<option value='TTTT'>팀장이상</option>
										<option value='PPPP'>파트너</option>
          									<%
          										for(int i = 0 ; i <dept_size ; i++){
          										CodeBean dept = depts[i];
          									%>
          								<option value='<%=dept.getCode()%>' <%if(gubun3.equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
          									<%}%>
        							</select>
        						</td>
								<td align="center">
									<input name="user_case_id" type="hidden">
									<input name="r_dept_id" type="hidden">
									<input name="user_nm" type="text" readonly class="text"  size="15" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+1%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="" size="15" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								</td>
							
								<td align="center"><%=j+2%></td>
								<td align="center">
									<select name='dept_id' onChange="javascript:User_search2('user_case_id',<%=j+2%>);">>	
          								<option value=''>선택</option>
          								<option value='AAAA'>전체</option>
          								<option value='TTTT'>팀장이상</option>
										<option value='PPPP'>파트너</option>
          									<%
          										for(int i = 0 ; i <dept_size ; i++){
          										CodeBean dept = depts[i];
          									%>
          								<option value='<%=dept.getCode()%>' <%if(gubun3.equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
          									<%}%>
        							</select>
        						</td>
								<td align="center">
									<input name="user_case_id" type="hidden">
									<input name="r_dept_id" type="hidden">
									<input name="user_nm" type="text" readonly class="text"  size="15" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+2%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="" size="15" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								</td>
							</tr>								
							<%}%>
							<tr>
								<td colspan="7" class='title'>누계</td>
								<td align="center">
									<input name="txtTot" class="text" value="" style="text-align:right;" size="15" readonly>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
	</tr>     

           
</form> 
</table> 
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--
	tot_buy_amt();
	<%if(acct_code.equals("00005")){%>
	cng_input();
	<%}%>
//-->
</script>
</body>             
</html>             