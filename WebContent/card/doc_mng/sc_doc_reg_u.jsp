<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.bill_mng.*, acar.user_mng.*, acar.serv_off.*,acar.car_service.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String card_user_id 	= request.getParameter("card_user_id")==null?"":request.getParameter("card_user_id");
	
	String app_st = "";
	String single_id = "";
	String single_name = "";
	
	String car_su = "1";
	String chk="0";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getXmlAuthRw(user_id, "04", "07", "12");
	
	// 추가2006.09.20 부서별 조회
	CodeBean[] depts = c_db.getCodeAll2("0002", "");
	int dept_size = depts.length;
	
	//카드정보
	CardDocBean cd_bean = CardDb.getCardDoc(cardno, buy_id);
	
	String buy_dt 	= cd_bean.getBuy_dt();
	String buy_user_id 		= cd_bean.getBuy_user_id();
	String reg_user_id 		= cd_bean.getReg_id();
	
	//단기계약 한건 조회-업무지원차량에 대한 정보
	Hashtable res = CardDb.getRentContCase(user_id);
  	
	String CAR_NO = res.get("CAR_NO")==null?"":String.valueOf(res.get("CAR_NO"));
	String CAR_MNG_ID = res.get("CAR_MNG_ID")==null?"":String.valueOf(res.get("CAR_MNG_ID"));
	String RENT_L_CD = res.get("RENT_L_CD")==null?"":String.valueOf(res.get("RENT_L_CD"));
	
	String SERV_DT = res.get("SERV_DT")==null?"":String.valueOf(res.get("SERV_DT"));
	String TOT_DIST = res.get("TOT_DIST")==null?"":String.valueOf(res.get("TOT_DIST"));
	
	//카드사용자정보
	Hashtable ht3 = new Hashtable();
	//ht3 = CardDb.getCardUserInfo(card_user_id); //사용자별 최근 사용카드 가져오기 
	ht3 = CardDb.getCardSearchExcel("", cardno);  //카드별 정보 가져오기
	
	
	//현재상태 표시 : 승인자 있을 경우 승인, 등록자만 있을 경우 미승인, 모두 없을 경우 미등록 
	if(!cd_bean.getApp_id().equals("")){
		if(cd_bean.getApp_id().equals("cancel")) app_st="매입취소";
		else if(cd_bean.getApp_id().equals("cance0")) app_st="승인취소";
		else app_st="승인";
	}else{
		if(!reg_user_id.equals("")) app_st="미승인";
		else app_st="미등록";
	}

	//혼자 선택시 실제사용자 아이디 가져오기 : 미등록시 유저, 미승인시 등록자	
	if(c_db.getNameById(buy_user_id, "USER").equals("")){
		single_id = user_id;
	}else{
		single_id = buy_user_id;
	}
	
	//혼자 선택시 사용자 이름 가져오기 : 미등록시 유저, 미승인시 등록자	
	if(c_db.getNameById(buy_user_id, "USER").equals("")){
		single_name = c_db.getNameById(user_id, "USER");
	}else{
		single_name = c_db.getNameById(buy_user_id, "USER");
	}
	
	//사장님카드 setting
	
	if ( cardno.equals("4009-0702-0423-7446") || cardno.equals("5535-3109-0005-0820") || cardno.equals("4009-0702-0741-6617")  || cardno.equals("4009-0702-0833-8646") ) {
		single_id = "000003";
	   single_name = c_db.getNameById("000003", "USER");
	}
		
     //감사 setting
     if ( cardno.equals("9410-8523-8465-4800") ) {
		single_id = "000035";
	   single_name = c_db.getNameById("000035", "USER");
	}
	
	//거래처정보
	Hashtable vendor = new Hashtable();
	if(!cd_bean.getVen_code().equals("")){
		vendor = neoe_db.getVendorCase(cd_bean.getVen_code());
	}
		
	dept_id 				= c_db.getUserDept(reg_user_id);
	String brch_id 			= c_db.getUserBrch(reg_user_id);
	String chief_id			= "000004";
	if(brch_id.equals("S1") && dept_id.equals("0001"))					chief_id = "000005";
	if(brch_id.equals("S1") && dept_id.equals("0002"))					chief_id = "000026";
	if(buy_user_id.equals("000003") || buy_user_id.equals("000035"))			chief_id = "";
	if(brch_id.equals("B1"))								chief_id = "000053";
	if(brch_id.equals("D1"))								chief_id = "000052";
	if(brch_id.equals("G1"))								chief_id = "000054";
	if(brch_id.equals("J1"))								chief_id = "000020";
	if(brch_id.equals("S2"))								chief_id = "000005";
		
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
			
	Vector vt_item = CardDb.getCardDocItemList(cardno, buy_id); 
 	int vt_i_size1 = vt_item.size();
 	
 	Hashtable f_ht_item = new Hashtable();
 	
 	if ( vt_i_size1 > 0) {
 	    car_su = Integer.toString(vt_i_size1);
 	    
       	f_ht_item = (Hashtable)vt_item.elementAt(0);
 	} 
 	
 	//아마존카 정직원 인원수 구하기(20191007)
 	Vector vt_acar = CardDb.getUserSearchList("", "", "AA", "Y");
 	int vt_acar_size = vt_acar.size() + 20;		//	여분 20명
 	if(vt_acar_size%2==1){	vt_acar_size +=	1;		 }	//	홀수이면 짝수가 되게 +1
 	
 	//코로나방역비 계
 //	int coamt= CardDb.getCardCorona(cardno);
 	int coamt= CardDb.getCardCoronaUser(single_id);
// 	out.println(coamt) ;
 	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language="JavaScript" src="/include/common.js"></script>
<style type="text/css">
	td {height: 30px;}
</style>
<script language="JavaScript">

	//차량대수에 따른 디스플레이
	function cng_input_carsu(car_su){
		var fm = document.form1;		
		
		var car_su = toInt(car_su) ;
								
		if(car_su >20){
			alert('입력가능한 최대건수는 20건 입니다.');
			return;
		}
		
	<%for(int i=1;i <= 19 ;i++){%>
					
				tr_acct_plus.style.display	= 'none';
			
				tr_acct3_1.style.display	= 'none';
				tr_acct3_2.style.display	= 'none';
				tr_acct3_3.style.display	= 'none';
				tr_acct98.style.display	= 'none';
				tr_acct97.style.display	= 'none';
				
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_2.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display	= 'none';		
				tr_acct3_<%=i%>_97.style.display	= 'none';
  <% } %>					
				
	<%for(int i=1;i <= 19 ;i++){%>
			if(car_su > <%=i%>){//우선 모두 안 보이게
			
				tr_acct_plus.style.display	= 'none';
			
				tr_acct3_1.style.display	= 'none';
				tr_acct3_2.style.display	= 'none';
				tr_acct3_3.style.display	= 'none';
				tr_acct98.style.display	= 'none';
				
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_2.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display	= 'none';		
	   
				if(fm.acct_code.value == '00006' || fm.acct_code_g[9].checked == true    ){//사고수리비&일반정비
				
					tr_acct_plus.style.display	= 'table-row';
					tr_acct3_1.style.display	= 'table-row';
					tr_acct3_3.style.display	= 'table-row';
					tr_acct98.style.display	= 'table-row';
					tr_acct3_<%=i%>_1.style.display	= 'table-row';
					tr_acct3_<%=i%>_3.style.display	= 'table-row';
					tr_acct3_<%=i%>_98.style.display	= 'table-row';		
					
				} else if (   fm.acct_code_g[8].checked == true  ){//차량유류대 		- 전기차 인경우 
			
					tr_acct_plus.style.display	= 'table-row';
					tr_acct3_1.style.display	= 'table-row';
					tr_acct3_2.style.display	= 'table-row';
					tr_acct98.style.display	= 'table-row';
					tr_acct3_<%=i%>_1.style.display	= 'table-row';				
					tr_acct3_<%=i%>_2.style.display	= 'table-row';				
					tr_acct3_<%=i%>_98.style.display	= 'table-row';					
				
				}else if(fm.acct_code_g[12].checked == true || fm.acct_code_g[10].checked == true ){//재리스정비&자동차검사
				
					tr_acct3_1.style.display	= 'table-row';		
					tr_acct98.style.display	= 'table-row';
					tr_acct3_<%=i%>_1.style.display	= 'table-row';
					tr_acct3_<%=i%>_98.style.display	= 'table-row';
				
				} else 	if(fm.acct_code.value == '00019'   ){// 주차요금 여러대 
				 
					tr_acct_plus.style.display	= 'table-row';
					tr_acct3_1.style.display	= 'table-row';			
					tr_acct98.style.display	= 'table-row';
					tr_acct97.style.display	= 'table-row';
					tr_acct3_<%=i%>_1.style.display	= 'table-row';				
					tr_acct3_<%=i%>_98.style.display	= 'table-row';		
					tr_acct3_<%=i%>_97.style.display	= 'table-row';			
									
				}else{//번호판대금&기타
					
					tr_acct3_98.style.display	= 'table-row';
					tr_acct3_<%=i%>_98.style.display	= 'table-row';
				}
		
				
			}else{
				
			}
	<%}%>						
	}		

	//등록&수정
	function Save(){
		var fm = document.form1;
				
		if(fm.cardno.value == '')	{	alert('카드번호가 누락됐습니다.'); 	fm.cardno.focus(); 		return; }
		if(fm.buy_dt.value == '')	{	alert('거래일자가 누락됐습니다.'); 	fm.buy_dt.focus(); 		return; }
		if(fm.buy_s_amt.value == '0'){	alert('거래금액이 누락됐습니다.'); 	fm.buy_s_amt.focus(); 	return; }
		if(fm.buy_v_amt.value != '0' && fm.ven_code.value == ''){	alert('거래금액이 누락됐습니다.'); return; }
		if(fm.buy_amt.value == '0'){	alert('거래금액이 누락됐습니다.'); 	fm.buy_amt.focus(); 	return; }		
		if(fm.ven_name.value == ''){	alert('거래처가 누락됐습니다.'); 	fm.ven_name.focus(); 	return; }
		if(fm.buy_user_nm.value == '' || fm.buy_user_id.value == ''){	alert('실제사용자를 검색해주세요.'); return; }	

		//ven_st 확인 
		if(fm.ven_st[0].checked == false && fm.ven_st[1].checked == false  && fm.ven_st[2].checked == false  && fm.ven_st[3].checked == false)
		{ 
			    alert('과세유형을 선택하십시오.'); 
			    fm.acct_code.value="";
				return;
		}
			
		
		//복리후생비
		if(fm.acct_code.value == '00001'  
			&& fm.acct_code_g[0].checked == false  && fm.acct_code_g[1].checked == false  && fm.acct_code_g[2].checked == false 
			&& fm.acct_code_g[3].checked == false && fm.acct_code_g[4].checked == false && fm.acct_code_g2[0].checked == false 
			&& fm.acct_code_g2[1].checked == false && fm.acct_code_g2[2].checked == false && fm.acct_code_g2[3].checked == false 
			&& fm.acct_code_g2[4].checked == false && fm.acct_code_g2[5].checked == false && fm.acct_code_g2[6].checked == false  && fm.acct_code_g2[7].checked == false  && fm.acct_code_g2[8].checked == false)
			{ alert('구분을 선택하십시오.'); return;}
		
		//복리후생비 - 기타는 임원이상, 이반장님 예외
		if((fm.acct_code.value == '00001'  && fm.acct_code_g[3].checked ==true) || (fm.acct_code.value == '00002')) {
		   if(fm.buy_user_id.value != "000003" && fm.buy_user_id.value != "000004" && fm.buy_user_id.value != "000005" 
				&& fm.buy_user_id.value != "000026"  && fm.buy_user_id.value != "000237" && fm.buy_user_id.value != "000028"  && fm.buy_user_id.value != "000035" ) 
 				{	alert('\'복리후생비 - 기타\'와 \'접대비\'에 대한 사용 권한이 없습니다.'); return;	}
		}
		
		//접대비		
		if(fm.acct_code.value == '00002' 			
			//&& fm.acct_code_g[17].checked == false && fm.acct_code_g[18].checked == false && fm.acct_code_g[19].checked == false)
			&& fm.acct_code_g[18].checked == false && fm.acct_code_g[19].checked == false && fm.acct_code_g[20].checked == false)
			{ alert('구분을 선택하십시오.'); return;}
			
		//여비교통비
		if(fm.acct_code.value == '00003' 	
			//&& fm.acct_code_g[13].checked == false && fm.acct_code_g[14].checked == false && fm.acct_code_g[15].checked == false && fm.acct_code_g[16].checked == false )
			&& fm.acct_code_g[14].checked == false && fm.acct_code_g[15].checked == false && fm.acct_code_g[16].checked == false && fm.acct_code_g[17].checked == false )
			{ alert('구분을 선택하십시오.'); return;}
			
		//차량유류비
		if(fm.acct_code.value == '00004' ) {
			
			//if(fm.acct_code_g[5].checked == false  && fm.acct_code_g[6].checked == false  && fm.acct_code_g[7].checked == false
			if(fm.acct_code_g[5].checked == false  && fm.acct_code_g[6].checked == false  && fm.acct_code_g[7].checked == false && fm.acct_code_g[8].checked == false		
				&& fm.acct_code_g2[9].checked == false && fm.acct_code_g2[10].checked == false && fm.acct_code_g2[11].checked == false)
				{ alert('구분을 선택하십시오.'); return;}		
			
			if ( fm.item_code[0].value == '' ||fm.item_code[0].value == 'null'  ) { alert('차량을 검색하여 선택하십시오.'); return;}
			
			
			if ( fm.acct_code_g2[9].checked == true) { // 업무용
			
				if ( fm.tot_dist[0].value == '' || fm.tot_dist[0].value == '0' ||  toInt(parseDigit(fm.tot_dist[0].value)) == 0   ) { alert('주행거리를 입력하십시오.'); return;}
				if ( fm.oil_liter[0].value == '' || fm.oil_liter[0].value == '0' ) { alert('주유량을 입력하십시오.'); return;}
				if ( toInt(parseDigit(fm.oil_liter[0].value)) > 75   ) { alert('주유량을 다시 한번 확인하시기 바랍니다.'); }
			
			}else{
			
				if ( fm.o_cau[0].value == '') { alert('사유를 선택하십시오.'); return;}
			}
						
			if (fm.acct_code_g[8].checked == true ) {  //전기차 
				var carsu = fm.car_su.value;
				 
				for(i=0; i<carsu ; i++){
					if ( fm.item_code[i].value == '') { alert('차량을 검색하여 선택하십시오.'); return;}
				}
			}else{
				if(fm.acct_cont[0].value == '')	{	alert('적요를 입력하십시오.'); return;	}
			}						
			
		}
		
		//차량정비비
		if(fm.acct_code.value == '00005') {
		  		          
			if(fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false
				&& fm.acct_code_g[12].checked == false && fm.acct_code_g[13].checked == false 
				&& fm.acct_code_g2[12].checked == false && fm.acct_code_g2[13].checked == false && fm.acct_code_g2[14].checked == false)  //정비 유형 추가 - 20171020 세무감사후 
						
				{ alert('구분을 선택하십시오.'); return;}			
			
			
			// 재리스정비인 경우 업무선택 불가  처리 	
			if (fm.acct_code_g[12].checked ==  true && fm.acct_code_g2[12].checked == true ) {
						 alert("재리스정비인경우 용도를 업무로 선택할 수 없습니다."); 
						 return;		
			}	
				
			//if (fm.acct_code_g[10].checked ==  true && fm.acct_code_g2[10].checked == true ) {
			//	 alert("자동차검사인경우 용도가 업무로 선택될 수 없습니다."); 
			//	 return;		
			//}	
			
			//정비는 반드시 차량 조회하여 car_mng_id 구한다.		
			if (fm.acct_code_g[11].checked == false && fm.acct_code_g[13].checked == false ) {
				var carsu = fm.car_su.value;
				 
				for(i=0; i<carsu ; i++){
					if ( fm.item_code[i].value == '') { alert('차량을 검색하여 선택하십시오.'); return;}
				}
			}else{
				if(fm.acct_cont[0].value == '')	{	alert('적요를 입력하십시오.'); return;	}
			}			
		}
		
		//사고수리비
		if (fm.acct_code.value == '00006'){
			var carsu = fm.car_su.value;
			
			for(i=0; i<carsu; i++){
				if(fm.item_code[i].value == '')		{ alert('차량을 검색하여 선택하십시오.'); return;}
				if(fm.acct_cont[i].value == '')		{ alert('적요를 입력하십시오.'); return;}
			}	
		}		
			
		//사무용품비&소모품비&통신비&도서인쇄비&지급수수료&비품&선급금
		if ((fm.acct_code.value == '00007' ||  fm.acct_code.value == '00008' ||  fm.acct_code.value == '00009'
			||  fm.acct_code.value == '00010' ||  fm.acct_code.value == '00011' ||  fm.acct_code.value == '00012' ||  fm.acct_code.value == '00013'  ||  fm.acct_code.value == '00021' ||  fm.acct_code.value == '00023' )
			&& fm.acct_cont[0].value == '')
			{ alert('적요를 입력하십시오.'); return;}
					
		//운반비, 주차요금 반드시 차량 조회하여 car_mng_id 구한다.
		if((fm.acct_code.value == '00018' ||  fm.acct_code.value == '00019') &&  fm.item_code[0].value == '') { alert('차량을 검색하여 선택하십시오.'); return;}
		
		//통신비
		//if(fm.acct_code.value == '00009' && fm.acct_code_g[20].checked == false && fm.acct_code_g[21].checked == false){ alert('구분을 선택하십시오.'); return;}
		if(fm.acct_code.value == '00009' && fm.acct_code_g[21].checked == false && fm.acct_code_g[22].checked == false){ alert('구분을 선택하십시오.'); return;}
			
		//적요 글자수 체크
		if(fm.acct_cont[0].value != '' && !max_length(fm.acct_cont[0].value,80))	{	alert('현재 적요 길이는 '+get_length(fm.acct_cont[0].value)+'자(공백포함) 입니다.\n\n적요는 한글40자/영문80자까지 입력이 가능합니다.'); return; } 			

		//전표일자 체크
		if(getRentTime('m', fm.buy_dt.value, <%=AddUtil.getDate()%>) > 3){ 
			if(!confirm('입력하신 전표일자가 석달이상 차이납니다.\n\n전표를 입력 하시겠습니까?'))			
				return;
		}
		
		var sMoney = 0;
		
		var call_nm_cnt =0;
		var call_tel_cnt =0;
		
		//정비비 금액 check - 카드결재액이 정비금액보다 클 수 없음. - 일반정비	, 재리스 정비 	
		if(fm.acct_code.value == '00005' ) {
		  // 일반정비	, 재리스 정비 
			if (fm.acct_code_g[9].checked ==  true  || fm.acct_code_g[12].checked ==  true ) {
	
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
								
					if ( sMoney+100 < toInt(parseDigit(fm.buy_amt.value))  ) {
					 	  alert('정비금액보다 결재금액이 클 수 없습니다. 확인하세요!!.'); 
					      return;				 
					}
						
					//정비금액과 결재금액 차이가 천원이상 안됨. - 20200103
					if ( sMoney  -  toInt(parseDigit(fm.buy_amt.value)) > 1000 ) {
					 	  alert('정비금액과 결재금액이 천원이상 차이가 납니다. 확인하세요!!.'); 
					      return;				 
					}
					
					if (fm.acct_code_g[9].checked ==  true ) {
						if(call_nm_cnt > 0)	{	alert('차량이용자를 입력하십시오.'); return; }
						if(call_tel_cnt > 0)	{	alert('연락처를 입력하십시오.'); 	return; }	
					}
			}	
			
	    }	
		
		//사고수리비 금액 check - 카드결재액이 정비금액보다 클 수 없음. - 일반정비	, 재리스 정비 	
		if(fm.acct_code.value == '00006' ) {
			// 		
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
							
				if ( sMoney+100 < toInt(parseDigit(fm.buy_amt.value))  ) {
				 	  alert('정비금액보다 결재금액이 클 수 없습니다. 확인하세요!!.'); 
				      return;				 
				}
					
				//정비금액과 결재금액 차이가 천원이상 안됨. - 20200103
				if ( sMoney  -  toInt(parseDigit(fm.buy_amt.value)) > 1000 ) {
				 	  alert('정비금액과 결재금액이 오천원이상 차이가 납니다. 확인하세요!!.'); 
				      return;				 
				}
				
				if(call_nm_cnt > 0)	{	alert('차량이용자를 입력하십시오.'); return; }
				if(call_tel_cnt > 0)	{	alert('연락처를 입력하십시오.'); 	return; }	
			
	    }	
		
		//주차요금 금액 check		
		if(fm.acct_code.value == '00019') {
		
			var car_su = toInt(fm.car_su.value);		
		
			for(i=0; i <car_su ; i++){			 				   
			   sMoney += toInt(parseDigit(fm.doc_amt[i].value));	
			}	
						
			if ( sMoney < toInt(parseDigit(fm.buy_amt.value)) || sMoney > toInt(parseDigit(fm.buy_amt.value))  ) {
			 	  alert('주차요금 차량별금액 합계와  결재금액이 다릅니다. 확인하세요!!.'); 
			      return;				 
			}
			
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
				strUserCnt = strUserCnt + fm.user_nm[i].value;
				if (inCnt > 1){
					strUserCnt = strUserCnt + ' 등';
					break;
				}
			
			}
			//나혼자 선택시 사용자명 직접 넣음.
			if(fm.acct_code_s[0].checked == true){
				if(fm.buy_user_id.value=='<%=user_id%>'){
					strUserCnt = "<%=single_name%>";
				}else{
					strUserCnt = fm.buy_user_nm.value;
				}				
			}
			
			fm.user_cont.value	=	strUserCnt;		
		}
		
		
		    //복리후생비인 경우 부서원 없이 금액 입력 못함. - 식대/ 중식 에 한함
		if(fm.acct_code.value == '00001' ) {		    
   
        	  if(fm.user_su.value == ''){ alert("인원수를 등록하셔야 합니다. 다시 확인 해주세요"); return; }
        	   
        	  if ( toInt(fm.user_su.value) == false ) { alert("인원수는 숫자여야 합니다. 다시 확인 해주세요"); return; }
        	  
        	        	  
        	  if(fm.txtTot.value == '' || fm.txtTot.value == '0' ){ alert("금액을 등록하셔야 합니다. 다시 확인 해주세요"); return; }		
        	  	  
           	  if(inCnt>0){
					for(i=0; i<inCnt ; i++){
					   strDept_id =  fm.dept_id[i].value;
					   strMoney =  fm.money[i].value;
					   
					   totMoney += toInt(parseDigit(fm.money[i].value));
					   
					//   alert(strDept_id);
					//   alert(strMoney);
					
				   if(fm.acct_code_s[0].checked == true){
						fm.user_su.value = 1;
						fm.user_case_id[0].value = fm.buy_user_id.value;
						fm.user_nm[0].value = "<%=c_db.getNameById(buy_user_id, "USER")%>";
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
           	strDept_id =  fm.dept_id.value;
			strMoney =  fm.buy_amt.value;
			totMoney += toInt(parseDigit(fm.buy_amt.value));
		}			
			
		var call_nm_cnt =0;
		var call_tel_cnt =0;
			    
		//개인별 지출금액 합계 점검
		if(fm.txtTot.value != '' && fm.txtTot.value != '0' && fm.txtTot.value != fm.buy_amt.value){ alert("합계와 누계가 맞지 않습니다. 다시 확인 해주세요"); return; }
	    
	   //정비비, 기타인 경우
		//if(fm.acct_code.value == '00005' && fm.acct_code_g[12].checked == true ){
		if(fm.acct_code.value == '00005' && fm.acct_code_g[13].checked == true ){
		   // 일단 총무팀 승인, 추후 계속 추가
		  if (fm.user_id.value == '000058' || fm.user_id.value == '000070'  || fm.user_id.value == '000063'  ||   fm.user_id.value == '000029' ||   fm.user_id.value == '000128' ||   fm.user_id.value == '000153') {
		  
		  } else {
		 	 alert('정비비 - 기타를 선택할 수 없습니다.!!!');
		 	 return;
		  } 		    
		}   		
			
		//주차비, 접대비, 복리후생비 기타 직원차량 유류대 부가세 0 check - 과세유형 선택후 셋팅값이 변경되기에 다시 계정선택하도록 함
		if ( fm.acct_code.value == "" ) {
			 alert('계정과목을 선택하세요!!!');
			 return;
		}
		
		if(confirm('등록하시겠습니까?')){	

			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
			
			document.domain = "amazoncar.co.kr";
			fm.action='sc_doc_reg_u_a.jsp';		
			fm.target='i_no';
//            fm.target='_self';
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
	
	//금액셋팅
	function tot_buy_amt(){
		var fm = document.form1;	
		
		//접대비, 차량유류대, 여비교통비가 아니고, 일반과세인 경우
		if(fm.acct_code.value != '00002' && fm.acct_code.value != '00003'  && fm.acct_code.value != '00019' && fm.acct_code.value != '00004' && fm.acct_code.value != '00005'  && fm.acct_code.value != '00009' && fm.ven_st[0].checked == true){
			if(fm.acct_code.value == '00001' && fm.acct_code_g[3].checked == true){
				fm.buy_s_amt.value 		= fm.buy_amt.value;
				fm.buy_v_amt.value 		= 0;
			}else if ( fm.acct_code.value == '00019'){	
				fm.buy_s_amt.value 		= fm.buy_amt.value;
				fm.buy_v_amt.value 		= 0;
			}else{
				fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
				fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));					
			}
		}else{	
			if(fm.acct_code.value == '00004' && fm.acct_code_g2[9].checked == true){		//업무면 
				fm.buy_s_amt.value 		= fm.buy_amt.value;
				fm.buy_v_amt.value 		= 0;	
			//} else 	
			//if(fm.acct_code.value == '00004' && fm.acct_code_g2[8].checked == false){		
			//	fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
			//	fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));	
			} else if(fm.acct_code.value == '00005' && fm.acct_code_g2[12].checked == true){		
				fm.buy_s_amt.value 		= fm.buy_amt.value;
				fm.buy_v_amt.value 		= 0;				
			//	fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
			//	fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));
		//	} else if(fm.acct_code.value == '00005' && fm.acct_code_g2[11].checked == false){			
		//		fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
		//		fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));
			} else if(fm.acct_code.value == '00002' || fm.acct_code.value == '00003' || fm.acct_code.value == '00009'|| fm.acct_code.value == '00019' ){			
				 fm.buy_s_amt.value 		= fm.buy_amt.value;
				 fm.buy_v_amt.value 		= 0;
			}else{	
				 if ( fm.ven_st[0].checked == true) {
					 fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
					 fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));				
				
				 } else {
					 fm.buy_s_amt.value 		= fm.buy_amt.value;
					fm.buy_v_amt.value 		= 0;				 
				 }				
				
			}
				
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
	
	//금액셋팅
	function set_buy_v_amt(){
		var fm = document.form1;	
		//접대비, 여비교통비 가 아니고, 일반과세인 경우
		if( fm.acct_code.value != '00002'  &&  fm.acct_code.value != '00003' && fm.ven_st[0].checked == true ){
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_s_amt.value)) * 0.1 );
		}else{
			fm.buy_v_amt.value = 0;				
		}
		set_buy_amt();			
	}	
	
	//거래처조회하기
	function search(idx){
		var fm = document.form1;	
		var t_wd;
		if(fm.ven_name.value != '')	fm.t_wd.value = fm.ven_name.value;		
		window.open("../doc_reg/sc_vendor_list2.jsp?idx="+idx+"&t_wd="+fm.t_wd.value, "VENDOR_LIST", "left=300, top=300, width=850, height=400, scrollbars=yes");		
	}
	function search_enter(idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') search(idx);
	}	
	
	//장기고객조회하기
	function Rent_search(idx1){
		var fm = document.form1;	
		var t_wd;	
		
	//	if( fm.acct_code.value == '00004' || fm.acct_code.value == '00005' || fm.acct_code.value == '00006' || fm.acct_code.value == '00018' || fm.acct_code.value == '00019')	{	idx1 = toInt(idx1);		}		
	
		if(fm.buy_dt.value == '')	{	alert('거래일자를 선택하십시오.'); 	fm.buy_dt.focus(); 		return; }
				
		//구분을 선택
		if(fm.acct_code.value == '00005' 	){ 	//차량정비비
			//if(fm.acct_code_g[8].checked == false && fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false && fm.acct_code_g[12].checked == false )
			if(fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false && fm.acct_code_g[12].checked == false && fm.acct_code_g[13].checked == false )
			{	alert('구분을 선택하십시오.'); 	fm.buy_dt.focus(); 		return; }
		}
					
		if(fm.item_name[idx1].value != ''){	fm.t_wd.value = fm.item_name[idx1].value;		}
		else{ 							alert('조회할 차량번호/상호를 입력하십시오.'); 	fm.item_name[idx1].focus(); 	return;}
		
		
		if(fm.acct_code.value == '00005' ) {		
			if (fm.acct_code_g[9].checked 	== true  || fm.acct_code_g[12].checked 	== true ) { //일반정비비, 재리스 정비비	
				window.open("../doc_reg/service_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value+"&buy_dt="+fm.buy_dt.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			
			} else {
			   	window.open("../doc_reg/rent_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value+"&go_url=/doc_mng/sc_doc_reg_u.jsp", "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			    
			}
		} else if (fm.acct_code.value == '00006') {
			window.open("../doc_reg/service_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value+"&buy_dt="+fm.buy_dt.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");
		} else if (fm.acct_code.value == '00004') {
			window.open("../doc_reg/rent_search.jsp?acct_code=00004&idx1="+idx1+"&t_wd="+fm.t_wd.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");	
	    } else {		
			window.open("../doc_reg/rent_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value+"&go_url=/doc_mng/sc_doc_reg_u.jsp", "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");		
		}
			
	}

	function Rent_enter(idx1) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Rent_search(idx1);
	}	
		
	//직원조회
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = fm.buy_user_nm.value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=250,top=250');		
		fm.action = "../card_mng/sc_user_search.jsp?nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();		
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
		fm.action = "../card_mng/sc_user_m_search.jsp?dept_id="+fm.dept_id[idx-1].value+"&nm="+nm+"&idx="+idx;
		fm.target = "User_search2";
		fm.submit();		
	}
	
	function enter2(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') User_search2(nm, idx);
	}	

	function cng_vs_input(){
		var fm = document.form1;
		
		//접대비가 아니고, 일반과세인 경우
		if(fm.acct_code.value !== '00002' && fm.acct_code.value !== '00003'  && fm.acct_code_g.value !== '3' && fm.ven_st[0].checked == true){
			fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));
		}else{
			fm.buy_s_amt.value 		= fm.buy_amt.value;
			fm.buy_v_amt.value 		= 0;	
		}
		
		tot_buy_amt();			
		
	}
	
	//계정과목 선택시
	function cng_input(val){
		var fm = document.form1;
		
		//우선 도우 안 보이게 만들기
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
		tr_acct98.style.display		= 'none';
		tr_acct97.style.display		= 'none';
		tr_acct99.style.display	 	= 'none';
		tr_acct101.style.display 	= 'none';	 
		tr_acct_plus.style.display	= 'none';   //차량대수 
		
	<%for(int i=1;i<=19 ;i++){%>
		tr_acct3_<%=i%>_1.style.display	= 'none';
		tr_acct3_<%=i%>_2.style.display	= 'none';
		tr_acct3_<%=i%>_3.style.display	= 'none';
		tr_acct3_<%=i%>_98.style.display= 'none';
		tr_acct3_<%=i%>_97.style.display= 'none';
	
	<%}%>	
		
		if(val == '00001'){ 		//복리후생비
			tr_acct1.style.display		= 'table-row';
			tr_acct98.style.display		= 'table-row';
			tr_acct99.style.display	 	= 'table-row';
			tr_acct101.style.display 	= 'table-row';	 
			fm.acct_code_g[0].checked 	= true;  //식대
			fm.acct_code_g2[1].checked 	= true;//중식
			fm.acct_code_s[0].checked = true;//1/n
					
		}else if(val == '00002'){ 	//접대비		
			tr_acct6.style.display		= 'table-row';
			tr_acct98.style.display		= 'table-row';
			tr_acct99.style.display		= 'table-row';
			tr_acct101.style.display 	= 'table-row';				
		
			fm.acct_code_g[18].checked 	= true;   //식대
			
		}else if(val == '00003'){ 	//여비교통비
			tr_acct4.style.display		= 'table-row';
			tr_acct98.style.display		= 'table-row';
			tr_acct99.style.display		= 'table-row';	
			tr_acct101.style.display 	= 'table-row';		
					
			fm.acct_code_g[14].checked 	= true;  //출장비
			
		}else if(val == '00004'){ 	//차량유류대
			tr_acct_plus.style.display	= 'none';   //차량대수 
			tr_acct2.style.display		= 'table-row';  //유종
			tr_acct3_1.style.display	= 'table-row';		
			tr_acct3_2.style.display	= 'table-row';					
			tr_acct98.style.display		= 'table-row';
						
			fm.acct_code_g[5].checked 	= true;  //가솔린
			fm.acct_code_g2[9].checked 	= true; //업무
						
		//	fm.car_su.value = '1';	
				
		}else if(val == '00005'){ 	//차량정비비
			tr_acct3.style.display		= 'table-row';
			tr_acct_plus.style.display	= 'table-row'; 
			tr_acct3_1.style.display	= 'table-row';
			tr_acct3_3.style.display	= 'table-row';
			tr_acct98.style.display		= 'table-row';
				
			fm.acct_code_g[9].checked = true;//일반정비 
			fm.acct_code_g2[12].checked 	= true; //업무 - 정비 
			
	//		fm.car_su.value = '1';	
								
		}else if(val == '00006'){ 	//사고수리비
			tr_acct_plus.style.display	= 'table-row';			
			tr_acct3_1.style.display	= 'table-row';
			tr_acct3_3.style.display	= 'table-row';
			tr_acct98.style.display		= 'table-row';
			
			fm.car_su.value = '1';	
			
		}else if(val == '00009'){ 	//통신비
			tr_acct7.style.display		= 'table-row';
			tr_acct98.style.display		= 'table-row';
						
			fm.acct_code_g[21].checked 	= true;  //개별
			
		}else if(val == '00016' || val == '00017'){ 	//대여사업차량/리스사업차량
			tr_acct8.style.display		= 'table-row';	
			tr_acct98.style.display		= 'table-row';
						
			fm.acct_code_g[23].checked 	= true;  //차량등록세
			
		}else if(val == '00018' ){ 	//운반비
			tr_acct3_1.style.display	= 'table-row';
			tr_acct98.style.display		= 'table-row';
		
		}else if(val == '00019'){ 	//주차요금 
			tr_acct_plus.style.display	= 'table-row'; 
			tr_acct3_1.style.display	= 'table-row';		
			tr_acct98.style.display		= 'table-row';	
			tr_acct97.style.display		= 'table-row';
			
			//대수가 1대이면
			if ( fm.car_su.value  == '1') {
				fm.doc_amt[0].value = fm.buy_amt.value;
			}
								
		}else{
			tr_acct98.style.display		= 'table-row';  //적요
			
		}
	
	}

	//복리후생비 구분 선택시
	function cng_input2(val){
		var fm = document.form1;
		
		tot_buy_amt();
		
		tr_acct1_1.style.display	= 'none';
		tr_acct1_2.style.display	= 'none';
		tr_acct98.style.display 	= 'none';
		tr_acct99.style.display 	= 'none';
		tr_acct101.style.display 	= 'none';
		
		if(val == '1'){ //식대
			fm.acct_code_g2[1].checked 	= true;
			tr_acct1_1.style.display	= 'table-row';
			tr_acct98.style.display 	= 'table-row';
			tr_acct99.style.display 	= 'table-row';
			tr_acct101.style.display 	= 'table-row';
			
		}
		if(val == '2'){ //회식비
			fm.acct_code_g2[3].checked 	= true;
			tr_acct1_2.style.display	= 'table-row';			
			tr_acct98.style.display 	= 'table-row';
			tr_acct99.style.display 	= 'table-row';			
			tr_acct101.style.display 	= 'table-row';
		
		}
		if(val == '15' || val == '3' || val == '30'){ //경조사, 기타, 포상휴가		
			tr_acct98.style.display 	= 'table-row';
			tr_acct99.style.display 	= 'table-row';			
			tr_acct101.style.display 	= 'table-row';
			
		}
		
	}	

	//복리후생비 회식비 구분 선택시	
	function cng_input22(val){
		var fm = document.form1;
				
		tr_acct98.style.display 	= 'table-row';
		tr_acct99.style.display 	= 'table-row';					
		tr_acct101.style.display 	= 'table-row';	
	}
	
	//통신비 구분 선택시	
	function cng_input7(val){
		
		var fm = document.form1;		
		if(val == '16'){			//개별			
			tr_acct99.style.display 	= 'table-row';					
			tr_acct101.style.display 	= 'table-row';			
		}
		if(val == '17'){			//공통
			tr_acct99.style.display 	= 'none';					
			tr_acct101.style.display 	= 'none';	
		
		}
	}
	
		//정비비 , 유류대 항목 구분 선택시
	function cng_input4(val){
	  	    
		var fm = document.form1;	
		
		fm.car_su.value='1';		
		cng_input_carsu(fm.car_su.value);
		
		 if(val == '6'){			//일반정비비 
			 	tr_acct_plus.style.display	= 'table-row';
				tr_acct3_1.style.display	= 'table-row';
				tr_acct3_3.style.display	= 'table-row';
				tr_acct98.style.display	= 'table-row';
		 
	    } else  if(val == '7' || val == '21'  ){			//자동차검사, 재리스 정비 
					
				tr_acct3_1.style.display	= 'table-row';
				tr_acct98.style.display	= 'table-row';
			
		 } else  if(val == '18' || val == '22'  ){			//번호판, 기타  
						
				tr_acct98.style.display	= 'table-row';
			
		 } else  if(val == '27'  ){			//전기차
		 			tr_acct_plus.style.display	= 'table-row';
					tr_acct3_1.style.display	= 'table-row';
					tr_acct3_2.style.display	= 'table-row';
					tr_acct98.style.display	= 'table-row';
		 } else {		 
					tr_acct3_1.style.display	= 'table-row';
					tr_acct3_2.style.display	= 'table-row';
					tr_acct98.style.display	= 'table-row';		 
		 }	
		
	}		
		
				
	//개인당 지출 금액(1/n:0, 금액직접입력:1)
	function cng_input1(){
		var fm 		= document.form1;
		var inCnt	= toInt(fm.user_su.value);
		var inTot	= toInt(parseDigit(fm.buy_amt.value));
		var innTot	= 0;
		var acar_cnt = fm.acar_cnt.value;	

//		if(inCnt > 100){	alert('1/n 입력은 최대 100인까지 입니다.'); return;}
		if(inCnt > acar_cnt){	alert('1/n 입력은 최대 '+acar_cnt+'인까지 입니다.'); return;}
		
		if(fm.user_Rdio[0].checked == true && inCnt > 0 && (toInt(parseDigit(fm.buy_amt.value)) > 0 || toInt(parseDigit(fm.buy_amt.value)) < 0 ))
		{
			var inAmt = Math.round(toInt(parseDigit(fm.buy_amt.value)) / inCnt);			

			for(i=0; i<inCnt ; i++){
				fm.money[i].value = parseDecimal(inAmt);
				innTot += inAmt;
				
				
			}
	//		for(i=inCnt; i<100 ; i++){
			for(i=inCnt; i<acar_cnt ; i++){
				fm.money[i].value = '0';
			}
			
			if(inTot > innTot) 	fm.money[0].value 		= parseDecimal(toInt(parseDigit(fm.money[0].value)) 	  + (inTot-innTot));
			if(inTot < innTot) 	fm.money[inCnt-1].value = parseDecimal(toInt(parseDigit(fm.money[inCnt-1].value)) + (inTot-innTot));
			
			fm.txtTot.value = fm.buy_amt.value;
			
		}
		
		if(fm.user_Rdio[1].checked == true)
		{
	//		for(i=0; i<100 ; i++){		
			for(i=0; i<acar_cnt ; i++){
				fm.money[i].value = '0';
			}
			fm.txtTot.value = '0';
		}
	}
		
	function cng_input_vat(){
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
	function Keyvalue(){
		var fm 		= document.form1;
		var innTot	= 0;
		var acar_cnt = fm.acar_cnt.value;
		
	//	for(i=0; i<100 ; i++){
		for(i=0; i<acar_cnt ; i++){
			innTot += toInt(parseDigit(fm.money[i].value));
		}
		fm.txtTot.value = parseDecimal(innTot);
	}
	
	function CardDocHistory(ven_code, cardno, buy_id){
		var fm = document.form1;
		window.open("../doc_reg/vendor_carddoc_nowyear_history.jsp?ven_code="+ven_code+"&cardno="+cardno+"&buy_id="+buy_id, "VENDOR_DOC_LIST", "left=10, top=10, width=950, height=600, scrollbars=yes");				
	}		
	
	function VendorHistory(ven_code){
		var fm = document.form1;
		window.open("../doc_reg/vendor_history.jsp?ven_code="+ven_code, "VENDOR_H_LIST", "left=10, top=10, width=1050, height=600, scrollbars=yes");				
	}
	
	//유류비경감요청문서기안
	function M_doc_action(st, m_doc_code, seq1, seq2, buy_user_id, doc_bit, doc_no){
		var fm = document.form1;
		fm.st.value 		= st;		
		fm.m_doc_code.value 	= m_doc_code;
		fm.seq1.value 		= seq1;
		fm.seq2.value 		= seq2;		
		fm.doc_bit.value 	= doc_bit;
		fm.doc_no.value 	= '';		
		fm.action = '/fms2/consignment/cons_oil_doc_u.jsp';		
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//국세청과세유형조회
	function search_nts(){
		var fm = document.form1;
		fm.nts_yn.value='Y';
		//window.open("http://www.nts.go.kr/cal/cal_check_02.asp", "NTS_SEARCH", "left=0, top=0, height=<%=s_height%>, width=<%=s_width%>, scrollbars=yes");
		window.open("https://teht.hometax.go.kr/websquare/websquare.html?w2xPath=/ui/ab/a/a/UTEABAAA13.xml", "NTS_SEARCH", "left=0, top=0, height=<%=s_height%>, width=<%=s_width%>, scrollbars=yes");
	}	
	
	function cng_input5(val){
		var fm = document.form1;
		
		if(fm.acct_code.value == '00001' ) {		
			tr_acct1.style.display		= 'table-row';	
        }
      
		if(val == '1'){ //나혼자
						
			fm.user_su.value = '1';
			fm.user_Rdio[0].checked = true;//1/n 자동으로 체크
			fm.user_case_id.value = "<%=single_id%>";
			fm.user_nm.value = "<%=single_name%>";
		
			if(fm.user_case_id.value != fm.buy_user_id.value){
				fm.user_case_id.value = fm.buy_user_id.value;
				fm.user_nm.value = fm.buy_user_nm.value;
			}
			
			tr_acct101.style.display 	= 'none';
				
			cng_input11();
		}
		if(val == '2'){ //파트너
		//	fm.user_su.value = "";
			tr_acct101.style.display 	= '';
			var idx = "1";
			var nm = "user_case_id";
			var dept_id = "PPPP";
			window.open("about:blank",'User_Group','scrollbars=yes,status=no,resizable=yes,width=600,height=400,left=370,top=200');		
			fm.action = "../card_mng/sc_user_m_search2.jsp?dept_id="+dept_id+"&nm="+nm+"&idx="+idx;
			fm.target = "User_Group";
			fm.submit();
						
		}
		if(val == '3'){ //선택
			fm.user_su.value = "";
			tr_acct101.style.display 	= '';
		}
	}
	
	//차량이용자조회
	function CarMgr_search(idx1){
		var fm = document.form1;	
		var t_wd;
	//	if(fm.acct_code.value == '00005' || fm.acct_code.value == '00006')	{	idx1 = toInt(idx1)+1;		}
		if(fm.rent_l_cd[idx1].value != ''){	fm.t_wd.value = fm.rent_l_cd[idx1].value;}
		else{ 							alert('조회할 차량번호를 입력하십시오.');  	return;}
		window.open("../doc_reg/s_man.jsp?idx1="+idx1+"&s_kd=3&t_wd="+fm.rent_l_cd[idx1].value, "CarMgr_search", "left=10, top=10, width=600, height=400, scrollbars=yes, status=yes, resizable=yes");				
		
	}
	
	//비용분담 인원 선택
	function cng_input11(){
		
		var fm = document.form1.user_Rdio;
		var val = '';
		for(i=0; i<fm.length; i++) {
			if(fm[i].checked == true) 	val=i;
		}
		
		cng_input1();
	}
	
	function cng_input3(){
		
		var fm = document.form1;
		
		tot_buy_amt();
		
		if(fm.acct_code_g2[8].checked == true){ //업무		- 유류
	     //	  alelt("aaa");	
			fm.item_name[0].value = "<%=CAR_NO%>";
			fm.acct_cont[0].value = "<%="(주)아마존카 - "+CAR_NO%>";
			fm.item_code[0].value = "<%=CAR_MNG_ID%>";
			fm.rent_l_cd[0].value = "<%=RENT_L_CD%>";
			fm.last_dist[0].value = "<%=TOT_DIST%>";
			fm.last_serv_dt[0].value = "<%=AddUtil.ChangeDate2((String)SERV_DT)%>";
			fm.tot_dist[0].value =""
			fm.oil_liter[0].value =""
			fm.o_cau[0].value =""
					
			fm.buy_amt.readOnly  = true;			
		
		} else if(fm.acct_code_g2[11].checked == true){ //업무	 - 정비  
	//	    alelt("bbb");	
		   fm.item_name[0].value = "";
			fm.acct_cont[0].value = "";
			fm.item_code[0].value = "";
			fm.rent_l_cd[0].value = "";
			fm.tot_dist[0].value =""
			fm.oil_liter[0].value =""
			fm.o_cau[0].value =""
			fm.last_dist[0].value = "";
			fm.last_serv_dt[0].value = "";
			
			fm.buy_amt.readOnly  = true;		
		
		}else{
						
				fm.item_name[0].value = "";
				fm.acct_cont[0].value = "";
				fm.item_code[0].value = "";
				fm.rent_l_cd[0].value = "";
				fm.tot_dist[0].value =""
				fm.oil_liter[0].value =""
				fm.o_cau[0].value =""
				fm.last_dist[0].value = "";
				fm.last_serv_dt[0].value = "";
				
				fm.buy_amt.readOnly  = false;				
		}		
		
	}
	
	//사업자등록번호 '-' 자동 입력
	function OnCheckBiz_no(oTa){ 
		var oForm = oTa.form ; 
		var sMsg = oTa.value ; 
		var onlynum = "" ; 
			onlynum = RemoveDash2(sMsg);
			
		if(event.keyCode != 8 ){ 
			if (GetMsgLen(onlynum) <= 2) oTa.value = onlynum ; 
			if (GetMsgLen(onlynum) == 3) oTa.value = onlynum + "-"; 
			if (GetMsgLen(onlynum) == 5) oTa.value = onlynum.substring(0,3) + "-" + onlynum.substring(3,5) + "-" + onlynum.substring(6,7); 
		} 
	}
	
	function RemoveDash2(sNo){ 
		var reNo = "" 
		
		for(var i=0; i<sNo.length; i++) { 
			if ( sNo.charAt(i) != "-" ) { 
				reNo += sNo.charAt(i) 
			} 
		} 
		return reNo 
	}
	
	function GetMsgLen(sMsg){ // 0-127 1byte, 128~ 2byte 
		var count = 0 
		for(var i=0; i<sMsg.length; i++) { 
			if ( sMsg.charCodeAt(i) > 127 ) { 
				count += 2 
			}else{ 
				count++ 
			} 
		} 
		return count 
	}
	
	
		//삭제
	function Del_app(){
		var fm = document.form1;
		if(confirm('삭제하시겠습니까?')){					
		if(confirm('진짜로 삭제하시겠습니까?')){					
		if(confirm('정말 삭제하시겠습니까?')){									
			fm.action='sc_doc_reg_del.jsp';		
			fm.target='i_no';

			fm.submit();
		}}}
	}
		

	//수정 - 주유카드중 전기차충전후 카드사용금액이 할인받아서 취소로 넘어욤. - 매출취소를 미등록상태로 변경  (아마존탁송이 사용하는 주유카드 )
	function Mod_app(){
		var fm = document.form1;
				
		if(confirm('매출취소를 미등록상태로 변경하시겠습니까?')){									
			fm.action='sc_doc_reg_del.jsp?cmd=oil';		
			fm.target='i_no';
	
			fm.submit();
		}
	}
		
</script>

</head>
<body <%if(app_st.equals("미등록")){%>onLoad="javascript: cng_input5('1'); "<%}%>>
<form action="" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
	<input type="hidden" name="buy_id" value="<%=buy_id%>">
	<input type='hidden' name='st' 	 value=''>
	<input type='hidden' name='m_doc_code' value=''>  
	<input type='hidden' name='seq1' 	 value=''>
	<input type='hidden' name='seq2' 	 value=''>
	<input type='hidden' name="doc_bit" 	 value="">
	<input type='hidden' name="doc_no" 	 value="">
	<input type='hidden' name='nts_yn' value=''>
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type="hidden" name="acar_cnt" value="<%=vt_acar_size%>">

<table border=0 cellspacing=0 cellpadding=0 width=98% class="search-area">
	<tr>
		<td colspan="2">
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td class="navigation">&nbsp; <span class=style1>재무회계 > 법인전표관리 > <span class=style5>New 카드전표관리</span></span></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>
    <tr> 
		<td colspan="2">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
    				<td><label><i class="fa fa-check-circle"></i> 거래정보 </label></td>
    				<td align="right">
    					<%if(reg_user_id.equals("") && cd_bean.getApp_id().equals("")){%>
    					   	
    					  <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
				      		<a id="submitLink" href="javascript:Save()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;
				      	    <%}%>	
						<%}else if(!reg_user_id.equals("") && cd_bean.getApp_id().equals("")){%>
							<%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("회계업무",user_id) || cd_bean.getBuy_user_id().equals(user_id)){%>
							<a id="submitLink" href="javascript:Save()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp;
							<%}%>
						<%}else{%>
							<%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("회계업무",user_id)){%>	
							<a id="submitLink" href="javascript:Save()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp;
							<%} %>
						<%} %>
			      	    <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
			      	    <%if(reg_user_id.equals("") && ( cd_bean.getApp_id().equals("") || cd_bean.getApp_id().equals("cance0") ) ){%>
			      	    	<%if(nm_db.getWorkAuthUser("전산팀",user_id) ){%>
			      	    		<a  href="javascript:Del_app()" style="margin-left:60px;"><img src=/acar/images/center/button_delete.gif border=0 align=absmiddle></a>
			      	    	<% }%>
			      	    	
			      	    <%}%><!-- 삭제 버튼 위치 변경 2018.02.27 -->
			      	    </td>
			      	</td>
    			</tr><!-- 
				<tr>
					<td class=line2 colspan=2></td>
				</tr> -->
			    <tr> 
			    	<td colspan="2" class="line">
			    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
							<tr>
								<td width="10%" class='title'>현재상태</td>
								<td width="15%">
									&nbsp;<input name="app_st" type="text" class="whitetext" value="<%=app_st%>" size="10"  style="font-weight: bold;"readonly>
									<% if ( !cd_bean.getReg_dt().equals("") && app_st.equals("매입취소")) { %>
										<%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
			      	    				<a  href="javascript:Del_app()" style="margin-left:60px;"><img src=/acar/images/center/button_delete.gif border=0 align=absmiddle></a>
			      	    				<% }%>
			      	    				<%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("회계업무",user_id)){%>
			      	    					<a  href="javascript:Mod_app()" style="margin-left:60px;">[매입으로]</a>
			      	    				<% }%>
			      	    			<% }%>
			      	    			<% if ( cd_bean.getReg_dt().equals("") && app_st.equals("매입취소")  ) { %> <!--  아마존탁송사용 주유관련  String.valueOf(ht3.get("BUY_USER_ID")).equals("000223")-->
			      	    				<%if (nm_db.getWorkAuthUser("전산팀",user_id)  ){%>
			      	    				<a  href="javascript:Mod_app()" style="margin-left:60px;"> [미등록으로] </a>
			      	    				<% }%>
			      	    			<% }%>
									</td>
								<td width='10%' class='title'>신용카드번호</td>
								<td width="15%">
									&nbsp;<input name="cardno" type="text" class="whitetext" value="<%=cardno%>" size="20" readonly></td>
								<td width="10%" class='title'>카드발급일자</td>
								<td width="*">
									&nbsp;<input name="card_sdate" type="text" class="whitetext" value='<%=AddUtil.ChangeDate3(String.valueOf(ht3.get("USE_S_DT")))%>' size="20" readonly></td>
							</tr>
							<tr>
								<td class='title'>사용자구분</td>
								<td>
									&nbsp;<input name="card_name" type="text" class="whitetext" value="<%=ht3.get("CARD_NAME")==null?"":ht3.get("CARD_NAME")%>" size="20" readonly></td>
								<td class='title'>등록자</td>
								<td>
									&nbsp;<input name="reg_id" type="text" class="whitetext" value="<%=c_db.getNameById(reg_user_id, "USER")%>" size="20" readonly>
								<td class='title'>등록일자</td>
								<td>
									&nbsp;<input name="reg_dt" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(cd_bean.getReg_dt())%>" size="20" readonly></td>
							</tr>
							<tr>
								<td class='title'><font color="red">*</font> 실제사용자</td>
								<td>
									&nbsp;<input name="buy_user_nm" type="text" class="text" value="<%=single_name%>" size="12" style='IME-MODE: active' onKeyDown="javasript:enter('buy_user_id', '0')">
									<input type="hidden" name="buy_user_id" value="<%=single_id%>">
									<a href="javascript:User_search('buy_user_id', '0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
								<td class='title'>승인자</td>
								<td>
									&nbsp;<input name="app_id" type="text" class="whitetext" value="<%=c_db.getNameById(cd_bean.getApp_id(), "USER")%>" size="30" readonly></td>
								<td class='title'>승인일자</td>
								<td>
									&nbsp;<input name="app_dt" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(cd_bean.getApp_dt())%>" size="20" readonly></td>
							</tr>
						</table>
			        </td>
			    </tr> 
      		</table>
      	</td>
    </tr>    
    <tr><td class=h></td></tr>
	<tr>
		<td colspan="2" class=line>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="3%" class='title' rowspan="3">거<br>래<br>대<br>금</td>
					<td width="7%" class='title'>공급가</td>
					<td width="15%">&nbsp;<input type="text" name="buy_s_amt" value="<%=Util.parseDecimal(cd_bean.getBuy_s_amt())%>" size="12" class=num   <% if( nm_db.getWorkAuthUser("전산팀",user_id) ||nm_db.getWorkAuthUser("해지관리자",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id)   ){%> <% } else { %> readonly <%} %> onBlur='javascript:this.value=parseDecimal(this.value); set_buy_v_amt();'>원</td><!-- onBlur='javascript:this.value=parseDecimal(this.value); set_buy_v_amt();' -->
					<td width="10%" class='title'>거래일자</td>
					<td width="*">&nbsp;<input class="whitetext" name="buy_dt" type="text" class="text" value="<%=AddUtil.ChangeDate2(cd_bean.getBuy_dt())%>" size="12" readonly></td>
				</tr>
				<tr>
					<td class='title'>부가세</td>
					<td>&nbsp;<input type="text" name="buy_v_amt" value="<%=Util.parseDecimal(cd_bean.getBuy_v_amt())%>" size="12" class=num  <% if( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("해지관리자",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id)  ){%> <% } else { %> readonly <%} %> onBlur='javascript:this.value=parseDecimal(this.value); set_buy_amt();'>원</td> <!-- onBlur='javascript:this.value=parseDecimal(this.value); set_buy_amt();' -->
					<td class='title'>거래처</td>
					<td>&nbsp;<input class="whitetext" name="ven_name" type="text" class="text" size="22" value="<%=cd_bean.getVen_name()%>" style='IME-MODE: active' onKeyDown="javasript:search_enter(1)" readonly>
						&nbsp;(사업자등록번호:<input type="text" class="whitetext" size="11" name="ven_nm_cd" value="<%=AddUtil.ChangeEnt_no(String.valueOf(vendor.get("S_IDNO")))%>" onfocus="OnCheckBiz_no(this.value)" onKeyup="OnCheckBiz_no(this.value)" readonly>)
						<input type="hidden" name="ven_code" value="<%=cd_bean.getVen_code()%>"> &nbsp;
						<a href="javascript:search(1);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
						&nbsp;<a href="javascript:CardDocHistory('<%=cd_bean.getVen_code()%>','<%=cd_bean.getCardno()%>','<%=cd_bean.getBuy_id()%>');"><img src=/acar/images/center/button_in_uselist.gif border=0 align=absmiddle></a>
						&nbsp;<a href="javascript:VendorHistory('<%=cd_bean.getVen_code()%>');"><img src=/acar/images/center/button_in_bgir.gif border=0 align=absmiddle></a><br>
						<div style="vertical-align:middle; padding-top:5px;">&nbsp;<font color="red" >※ 영수증과 위의 거래처 정보가 다른 경우, '검색'을 눌러 올바른 정보로 수정바랍니다.</font></div>
					</td>
				</tr>
				<tr>
					<td class='title'>합계</td>
					<td>&nbsp;<input type="text" name="buy_amt" value="<%=Util.parseDecimal(cd_bean.getBuy_amt())%>" size="12" class=num readonly>원<!--  onBlur='javascript:this.value=parseDecimal(this.value); tot_buy_amt();' -->
					</td>
					<td class='title'>과세유형</td>
					<td>
						&nbsp;<input type="radio" name="ven_st" value="1" <%if(cd_bean.getVen_st().equals("1"))%>checked<%%>  onClick="javascript:cng_vs_input()">일반과세
			     		&nbsp;<input type="radio" name="ven_st" value="2" <%if(cd_bean.getVen_st().equals("2"))%>checked<%%>  onClick="javascript:cng_vs_input()">간이과세
			     		&nbsp;<input type="radio" name="ven_st" value="3" <%if(cd_bean.getVen_st().equals("3"))%>checked<%%>  onClick="javascript:cng_vs_input()">면세
			     		&nbsp;<input type="radio" name="ven_st" value="4" <%if(cd_bean.getVen_st().equals("4"))%>checked<%%>  onClick="javascript:cng_vs_input()">비영리법인(국가기관/단체)
						<%-- <%if(cd_bean.getVen_st().equals("1"))%><input type="text" name="" value="일반과세" size="8" class="whitetext" readonly><input type="hidden" name="ven_st" value='1'><%%> 
						<%if(cd_bean.getVen_st().equals("2"))%><input type="text" name="" value="간이과세" size="8" class="whitetext" readonly><input type="hidden" name="ven_st" value='2'><%%> 
						<%if(cd_bean.getVen_st().equals("3"))%><input type="text" name="" value="면세" size="8" class="whitetext" readonly><input type="hidden" name="ven_st" value='3'><%%> 
						<%if(cd_bean.getVen_st().equals("4"))%><input type="text" name="" value="비영리법인(국가기관/단체)" size="25" class="whitetext" readonly><input type="hidden" name="ven_st" value='4'><%%> --%> 
						&nbsp; <a href="javascript:search_nts();"><img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>
	<tr>
		<td colspan="2"><label><i class="fa fa-check-circle"></i> 사용내역 </label></td>
	</tr>
	<tr>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>계정과목</td>
			    	<td width="*">&nbsp;
	  					<select name="acct_code" onchange="javascript:cng_input(this.options[this.selectedIndex].value); cng_input3(); tot_buy_amt();">
		  					<optgroup label="직원">
				  				<option value="00001"<%if(cd_bean.getAcct_code().equals("00001"))%> selected<%%>>복리후생비</option>
				  				<option value="00002"<%if(cd_bean.getAcct_code().equals("00002"))%> selected<%%>>접대비</option>
				  				<option value="00003"<%if(cd_bean.getAcct_code().equals("00003"))%> selected<%%>>여비교통비</option>
				  				<option value="00004"<%if(cd_bean.getAcct_code().equals("00004"))%> selected<%%>>차량유류대</option>
				  				<option value="00005"<%if(cd_bean.getAcct_code().equals("00005"))%> selected<%%>>차량정비비</option>
				  				<option value="00006"<%if(cd_bean.getAcct_code().equals("00006"))%> selected<%%>>사고수리비</option>
				  				<option value="00007"<%if(cd_bean.getAcct_code().equals("00007"))%> selected<%%>>사무용품비</option>
				  				<option value="00009"<%if(cd_bean.getAcct_code().equals("00009"))%> selected<%%>>통신비</option>
			  				</optgroup>
			  				<optgroup label="공통">
			  					<option value="00008"<%if(cd_bean.getAcct_code().equals("00008"))%> selected<%%>>소모품비</option>
			  					<option value="00010"<%if(cd_bean.getAcct_code().equals("00010"))%> selected<%%>>도서인쇄비</option>
			  					<option value="00011"<%if(cd_bean.getAcct_code().equals("00011"))%> selected<%%>>지급수수료</option>
			  					<option value="00012"<%if(cd_bean.getAcct_code().equals("00012"))%> selected<%%>>비품</option>
			  					<option value="00013"<%if(cd_bean.getAcct_code().equals("00013"))%> selected<%%>>선급금</option>
			  					<option value="00014"<%if(cd_bean.getAcct_code().equals("00014"))%> selected<%%>>교육훈련비</option>
			  					<option value="00015"<%if(cd_bean.getAcct_code().equals("00015"))%> selected<%%>>세금과공과</option>
			  					<option value="00016"<%if(cd_bean.getAcct_code().equals("00016"))%> selected<%%>>대여사업차량</option>
			  					<option value="00017"<%if(cd_bean.getAcct_code().equals("00017"))%> selected<%%>>리스사업차량</option>
			  					<option value="00018"<%if(cd_bean.getAcct_code().equals("00018"))%> selected<%%>>운반비</option>
			  					<option value="00019"<%if(cd_bean.getAcct_code().equals("00019"))%> selected<%%>>주차요금</option>
			  					<option value="00021"<%if(cd_bean.getAcct_code().equals("00021"))%> selected<%%>>업무비선급금</option>
			  					<option value="00023"<%if(cd_bean.getAcct_code().equals("00023"))%> selected<%%>>광고선전비</option>
			  				</optgroup>					  				
			  			</select>
			  		</td>
			    </tr>		
			</table>
		</td>
	</tr>
	<tr id=tr_acct1 style='display:<%if(cd_bean.getAcct_code().equals("00001")){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" rowspan="2" class='title'>구분</td>
					<td width="*">&nbsp;
						<input type="radio" name="acct_code_g" value="1" onClick="javascript:cng_input2(this.value)" <%if(cd_bean.getAcct_code_g().equals("1") || cd_bean.getAcct_code_g().equals(""))%>checked<%%>>식대
						<input type="radio" name="acct_code_g" value="2" onClick="javascript:cng_input2(this.value)" <%if(cd_bean.getAcct_code_g().equals("2"))%>checked<%%>>회식비
						<input type="radio" name="acct_code_g" value="15" onClick="javascript:cng_input2(this.value)" <%if(cd_bean.getAcct_code_g().equals("15"))%>checked<%%>>경조사	
						<input type="radio" name="acct_code_g" value="3" onClick="javascript:cng_input2(this.value)" <%if(cd_bean.getAcct_code_g().equals("3"))%>checked<%%>>기타	
						<input type="radio" name="acct_code_g" value="30" disabled  onClick="javascript:cng_input2(this.value)" <%if(cd_bean.getAcct_code_g().equals("30"))%>checked<%%>>포상휴가				
					</td>
				</tr>
				<tr>
					<td>
						<table width="90%"  border="0" cellpadding="0" cellspacing="0">
							<tr id=tr_acct1_1 style='display:<%if(cd_bean.getAcct_code_g().equals("1") || cd_bean.getAcct_code_g2().equals("")){%>table-row<%}else{%>none<%}%>'>
								<td>&nbsp;
									<input type="radio" name="acct_code_g2" value="1" onClick="javascript:cng_input3(this.value)" <%if(cd_bean.getAcct_code_g2().equals("1"))%>checked<%%>>조식
									<input type="radio" name="acct_code_g2" value="2" onClick="javascript:cng_input3(this.value)" <%if(cd_bean.getAcct_code_g2().equals("2") || cd_bean.getAcct_code_g2().equals(""))%>checked<%%>>중식
									<input type="radio" name="acct_code_g2" value="3" onClick="javascript:cng_input3(this.value)" <%if(cd_bean.getAcct_code_g2().equals("3"))%>checked<%%>>특근식
								</td>
							</tr>
							<tr id=tr_acct1_2 style='display:<%if(cd_bean.getAcct_code_g().equals("2")){%>table-row<%}else{%>none<%}%>'>
								<td>&nbsp;
									<input type="radio" name="acct_code_g2" value="15" <%if(cd_bean.getAcct_code_g2().equals("15"))%>checked<%%>>사내동호회
									<input type="radio" name="acct_code_g2" value="4" <%if(cd_bean.getAcct_code_g2().equals("4"))%>checked<%%>>회사전체모임
									<input type="radio" name="acct_code_g2" value="5" <%if(cd_bean.getAcct_code_g2().equals("5"))%>checked<%%>>부서별 정기모임
									<input type="radio" name="acct_code_g2" value="6" <%if(cd_bean.getAcct_code_g2().equals("6"))%>checked<%%>>부서별 부정기회식
									<br>&nbsp;&nbsp;<input type="radio" name="acct_code_g2" value="31" <%if(cd_bean.getAcct_code_g2().equals("31"))%>checked<%%>>사무실음료비치용
									&nbsp;&nbsp;&nbsp;&nbsp;<font color=blue>*사무실음료비치는 부서원 협의가 있는 경우에 한하여 복지비로 선택하여 처리할 수 있음. 비용은 부서원 균등부담 </font> 	
									<br>&nbsp;&nbsp;<input type="radio" name="acct_code_g2" value="33" <%if(cd_bean.getAcct_code_g2().equals("33"))%>checked<%%>>코로나방역비	
									&nbsp;(* 누계사용액 : <%=Util.parseDecimal(coamt)%> )  																	
								</td>
							</tr>
					     </table>
					</td>
				</tr>	
			</table>
		</td>
	</tr>
	<tr id=tr_acct2 style='display:<%if(cd_bean.getAcct_code().equals("00004")){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="5%" class='title' rowspan="2">구분</td>
          			<td width="5%" class='title'>유종</td>
					<td width="*">&nbsp;
						<input type="radio" name="acct_code_g" value="13"  onClick="javascript:cng_input4(this.value);" <%if(cd_bean.getAcct_code_g().equals("13"))%>checked<%%>>가솔린
						<input type="radio" name="acct_code_g" value="4"   onClick="javascript:cng_input4(this.value);" <%if(cd_bean.getAcct_code_g().equals("4"))%>checked<%%>>디젤
						<input type="radio" name="acct_code_g" value="5"   onClick="javascript:cng_input4(this.value);" <%if(cd_bean.getAcct_code_g().equals("5"))%>checked<%%>>LPG			
						<input type="radio" name="acct_code_g" value="27"  onClick="javascript:cng_input4(this.value);" <%if(cd_bean.getAcct_code_g().equals("27"))%>checked<%%>>전기/수소	<!-- 전기차충전 추가 -->
					</td>
				</tr>
				<tr>
					<td class='title'>용도</td>
					<td> &nbsp;
						<input type="radio" name="acct_code_g2" value="11" <%if(cd_bean.getAcct_code_g2().equals("11"))%>checked<%%> onClick="javascript:cng_input3(this.value)">업무
						<input type="radio" name="acct_code_g2" value="12" <%if(cd_bean.getAcct_code_g2().equals("12"))%>checked<%%> onClick="javascript:cng_input3(this.value)">예비차 보충
						<input type="radio" name="acct_code_g2" value="13" <%if(cd_bean.getAcct_code_g2().equals("13"))%>checked<%%> onClick="javascript:cng_input3(this.value)">고객차량
					</td>
				</tr>	
			</table>
		</td>
	</tr>
	<tr id=tr_acct3 style='display:<%if(cd_bean.getAcct_code().equals("00005")){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="5%" class='title' rowspan="2">구분</td>
					<td width="5%" class='title'>유형</td>
				   <td width="*">&nbsp;
						<input type="radio" name="acct_code_g" value="6"  onClick="javascript:cng_input4(this.value);" <%if(cd_bean.getAcct_code_g().equals("6"))%>checked<%%>>일반정비
						<input type="radio" name="acct_code_g" value="7"  onClick="javascript:cng_input4(this.value);" <%if(cd_bean.getAcct_code_g().equals("7"))%>checked<%%>>자동차검사
						<!--<input type="radio" name="acct_code_g" value="8"  onClick="javascript:cng_input4(this.value)" <%if(cd_bean.getAcct_code_g().equals("8"))%>checked<%%>>점검기록부 -->	
						<input type="radio" name="acct_code_g" value="18" onClick="javascript:cng_input4(this.value);" <%if(cd_bean.getAcct_code_g().equals("18"))%>checked<%%>>번호판대금
						<input type="radio" name="acct_code_g" value="21" onClick="javascript:cng_input4(this.value);" <%if(cd_bean.getAcct_code_g().equals("21"))%>checked<%%>>재리스정비
						<input type="radio" name="acct_code_g" value="22" onClick="javascript:cng_input4(this.value);" <%if(cd_bean.getAcct_code_g().equals("22"))%>checked<%%>>기타
					</td>
				</tr>
				</tr>
				<tr>
					<td class='title'>용도</td>
					<td> &nbsp;
						<input type="radio" name="acct_code_g2" value="21" <%if(cd_bean.getAcct_code_g2().equals("21"))%>checked<%%> onClick="javascript:cng_input3(this.value)">업무
						<input type="radio" name="acct_code_g2" value="22" <%if(cd_bean.getAcct_code_g2().equals("22"))%>checked<%%> onClick="javascript:cng_input3(this.value)">예비차
						<input type="radio" name="acct_code_g2" value="23" <%if(cd_bean.getAcct_code_g2().equals("23"))%>checked<%%> onClick="javascript:cng_input3(this.value)">고객차
					</td>
				</tr>	
			</table>
		</td>
	</tr>
	<tr id=tr_acct4 style='display:<%if(cd_bean.getAcct_code().equals("00003")){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>구분</td>
					<td>&nbsp;
						<input type="radio" name="acct_code_g" value="9"  <%if(cd_bean.getAcct_code_g().equals("9"))%>checked<%%>>출장비
						<input type="radio" name="acct_code_g" value="10" <%if(cd_bean.getAcct_code_g().equals("10"))%>checked<%%>>기타교통비
						<input type="radio" name="acct_code_g" value="20" <%if(cd_bean.getAcct_code_g().equals("20"))%>checked<%%>>하이패스
						<input type="radio" name="acct_code_g" value="32" <%if(cd_bean.getAcct_code_g().equals("32"))%>checked<%%>>제안참석
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr id=tr_acct6 style='display:<%if(cd_bean.getAcct_code().equals("00002")){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>구분</td>
					<td>&nbsp;
						<input type="radio" name="acct_code_g" value="11" <%if(cd_bean.getAcct_code_g().equals("11"))%>checked<%%>>식대
						<input type="radio" name="acct_code_g" value="12" <%if(cd_bean.getAcct_code_g().equals("12"))%>checked<%%>>경조사
						<input type="radio" name="acct_code_g" value="14" <%if(cd_bean.getAcct_code_g().equals("14"))%>checked<%%>>기타
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr id=tr_acct7 style='display:<%if(cd_bean.getAcct_code().equals("00009")){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>구분</td>
					<td>&nbsp;
						<input type="radio" name="acct_code_g" value="16" onClick="javascript:cng_input7(this.value)" <%if(cd_bean.getAcct_code_g().equals("16"))%>checked<%%>>개별
						<input type="radio" name="acct_code_g" value="17" onClick="javascript:cng_input7(this.value)" <%if(cd_bean.getAcct_code_g().equals("17"))%>checked<%%>>공통
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr id=tr_acct8 style='display:<%if(cd_bean.getAcct_code().equals("00016")||cd_bean.getAcct_code().equals("00017")){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>구분</td>
					<td>&nbsp;
						<input type="radio" name="acct_code_g" value="19" <%if(cd_bean.getAcct_code_g().equals("19"))%>checked<%%>>차량등록세
						<input type="radio" name="acct_code_g" value="23" <%if(cd_bean.getAcct_code_g().equals("23"))%>checked<%%>>차량취득세
						<input type="radio" name="acct_code_g" value="24" <%if(cd_bean.getAcct_code_g().equals("24"))%>checked<%%>>차량자동차세
						<input type="radio" name="acct_code_g" value="25" <%if(cd_bean.getAcct_code_g().equals("25"))%>checked<%%>>차량환경개선부담금
						<input type="radio" name="acct_code_g" value="26" <%if(cd_bean.getAcct_code_g().equals("26"))%>checked<%%>>차량개별소비세			
					 </td>
				</tr>
			</table>
		</td>
	</tr>	
	<tr id=tr_acct_plus style='display:<%if(  ( cd_bean.getAcct_code().equals("00004") && cd_bean.getAcct_code_g().equals("27") )  || ( cd_bean.getAcct_code().equals("00005") && cd_bean.getAcct_code_g().equals("6")) ||   cd_bean.getAcct_code().equals("00006")  ){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" >
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" ></td>
					<td align=right>
						&nbsp;입력 대수 : <input type="text" name="car_su" value="<%=car_su%>" size="2" class="text" onBlur='javscript:cng_input_carsu(this.value);'>&nbsp;&nbsp;&nbsp;건
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=red>* 입력 대수는 20대까지 가능합니다.</font>
					</td> 
				</tr>
			</table>
		</td>
	</tr>	
	<tr id=tr_acct3_1 style='display:<%if(cd_bean.getAcct_code().equals("00004") || cd_bean.getAcct_code().equals("00018") || cd_bean.getAcct_code().equals("00019") 
			|| ( cd_bean.getAcct_code().equals("00005") && (cd_bean.getAcct_code_g().equals("7") || cd_bean.getAcct_code_g().equals("21")) ) ){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>차량</td>
					<td width="25%">&nbsp;
						<input name="item_name" type="text" class="text" value="<%=cd_bean.getItem_name()%>" size="20" style='IME-MODE: active' onKeyDown="javasript:Rent_enter('0')">
						<input type="hidden" name="rent_l_cd" value="<%=cd_bean.getRent_l_cd()%>">
						<input type="hidden" name="serv_id" value="<%=cd_bean.getServ_id()%>">
						<input type="hidden" name="item_code" value="<%=cd_bean.getItem_code()%>">
						<input type="hidden" name="stot_amt" value="">
						<input type="hidden" name="firm_nm" value="">
						<a href="javascript:Rent_search('0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a><br>
						&nbsp;(차량번호/상호로 검색)
					</td> 
					<td width="10%" class='title'>최근주행거리</td>
					<td width="35%" align="left">&nbsp;&nbsp;<input class="whitetext" type="text" name="last_dist" value="" size="10" class=num style="text-align: right;"readonly>&nbsp;km</td>
					<td width="8%" class='title'>최근등록일</td>
					<td width="12%" align="left">&nbsp;&nbsp;<input class="whitetext" type="text" name="last_serv_dt" value="" size="10" readonly>&nbsp;</td>
				</tr>     
			</table>
		</td>
	 </tr>
	<tr id=tr_acct3_2 style='display:<%if(cd_bean.getAcct_code().equals("00004")){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>사유</td>
					<td width="25%">&nbsp;
						<select name="o_cau" >
							<option value="">--선택--</option>
						<%for(int i = 0 ; i < c_size ; i++){
								CodeBean code = codes[i];	%>
							<option value='<%=code.getNm_cd()%>' <%if(cd_bean.getO_cau().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
						<%}%>
						</select>
						<br>
						&nbsp;*업무용인 경우 선택안해도 됨.
					<%if(!from_page.equals("/fms2/consignment/cons_oil_doc_frame.jsp") && (nm_db.getWorkAuthUser("전산팀",user_id)||user_id.equals(reg_user_id)||user_id.equals(cd_bean.getBuy_user_id())) && cd_bean.getBuy_amt()>0 && cd_bean.getAcct_code_g2().equals("12") && cd_bean.getAcct_code().equals("00004") && cd_bean.getM_doc_code().equals("")){%>
						<font color=red>[유류대경감요청공문</font><a href="javascript:M_doc_action('card', '', '<%=cd_bean.getCardno()%>', '<%=cd_bean.getBuy_id()%>', '<%=cd_bean.getBuy_user_id()%>', '1', '');" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='유류대경감요청공문 기안하기'><img src="/acar/images/center/button_in_gian.gif" align="absmiddle" border="0"></a><font color=red>]</font>
					<%}%>
					<td width="10%" class='title'>주유(충전)량</td>
					<td width="35%">&nbsp;
						<input type='text' size='7' class='num'  value="<%=cd_bean.getOil_liter()%>" name='oil_liter' >&nbsp;L (전기kWh,수소kg)
						<br>
						&nbsp;*업무용인 경우 필수 (소숫점세자리까지 입력가능)		
					</td>
					<td width="8%" class='title'>주행거리</td>
					<td width="12%">&nbsp;
						<input type='text' size='6' class='num'  name='tot_dist' value='<%=cd_bean.getTot_dist()%>' >&nbsp;km		
					</td>
				</tr>	
			</table>
		</td>
	</tr>
	<tr id=tr_acct3_3 style='display:none;'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>차량이용자</td>
					<td width="25%">&nbsp;
		  				<input type='text' size='30' class='text' name='call_t_nm' value="<%=cd_bean.getCall_t_nm()%>" >		                
					 </td>
					<td width="10%" class='title'>연락처</td>
					<td width="55%">&nbsp;
						<input type='text' size='30' class='text'  name='call_t_tel' value="<%=cd_bean.getCall_t_tel()%>" >
						<a href="javascript:CarMgr_search('0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>	
					</td>
				</tr>
			</table>
		</td>
	</tr>  
    <tr id=tr_acct97 style='display:<%if(cd_bean.getAcct_code().equals("00019")){%>table-row<%}else{%>none<%}%>'>
    	<td colspan="2" >
    		<table border="0" cellspacing="0" cellpadding="0" width='100%'>
        		<tr>
        			<td class="line">
	        			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        			<tr>
			          			<td width="10%" class='title'>금액</td>
			          			<td>&nbsp;
			            			<input name="doc_amt" class="num" value="<%=Util.parseDecimal(String.valueOf(f_ht_item.get("DOC_AMT")))%>" size="12" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value);'>원
			            		</td>
			            	</tr>
			            </table>
			        </td>    		
        		</tr>
      		</table>
      	</td>
    </tr> 	 	
	<tr id=tr_acct98 style='display:table-row'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>적요</td>
				    <td>&nbsp;
						<textarea name="acct_cont" cols="90" rows="2" class="text"><%=cd_bean.getAcct_cont()%></textarea>
						(한글40자이내)
					</td>
				</tr>
			</table>
		</td>
	</tr> 

    <tr>
    	<td class=h></td>
    </tr>
    
 <%	 
 	 
 	 String ht_item_name = "";
 	 String ht_rent_l_cd = "";
 	 String ht_item_code = "";
 	 String ht_serv_id = "";
 	 String ht_call_t_nm = "";
 	 String ht_call_t_tel = "";
 	 String ht_o_cau = "";
 	 String ht_oil_liter = "";
  	 String ht_tot_dist = "";
  	 String ht_doc_amt = "";
 	
 	 String ht_acct_cont = ""; 	 
 	 
      for(int j=1; j<= 19; j++){
      
        if ( j < vt_i_size1 ) {
        	Hashtable ht_item = (Hashtable)vt_item.elementAt(j);
        	ht_item_name = String.valueOf(ht_item.get("ITEM_NAME"));
        	ht_rent_l_cd = String.valueOf(ht_item.get("RENT_L_CD"));
        	ht_item_code = String.valueOf(ht_item.get("ITEM_CODE"));
        	ht_serv_id = String.valueOf(ht_item.get("SERV_ID"));
        	ht_call_t_nm = String.valueOf(ht_item.get("CALL_T_NM"));
        	ht_call_t_tel = String.valueOf(ht_item.get("CALL_T_TEL"));
        	ht_acct_cont = String.valueOf(ht_item.get("ACCT_CONT"));
         	ht_o_cau = String.valueOf(ht_item.get("O_CAU"));
        	ht_oil_liter =String.valueOf(ht_item.get("OIL_LITER"));
     		ht_tot_dist = String.valueOf(ht_item.get("TOT_DIST")); 	
         	ht_doc_amt = String.valueOf(ht_item.get("DOC_AMT"));
        	        			        					
        } else {	
        	ht_item_name = "";
        	ht_rent_l_cd = "";
        	ht_item_code = "";
        	ht_serv_id = "";
        	ht_call_t_nm = "";
     		ht_call_t_tel = "";
     		ht_acct_cont = ""; 	
     		ht_o_cau = "";  
     		ht_oil_liter = "";
     		ht_tot_dist = "";		
     		ht_doc_amt = "";
        }
        
  	%>
     <tr id=tr_acct3_<%=j%>_1  style='display:<%if( j < vt_i_size1 ){%>table-row<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="10%" class='title'>차량</td>
       	<td width="33%">&nbsp;
            <input name="item_name" type="text" class="text" value="<%=ht_item_name%>" size="20" style='IME-MODE: active' onKeyDown="javasript:Rent_enter('<%=j%>')">
				<input type="hidden" name="rent_l_cd" value="<%=ht_rent_l_cd%>">
				<input type="hidden" name="serv_id" value="<%=ht_serv_id%>">
				<input type="hidden" name="item_code" value="<%=ht_item_code%>">
				<input type="hidden" name="stot_amt" value="">
				<input type="hidden" name="firm_nm" value="">
            <a href="javascript:Rent_search('<%=j%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>&nbsp;(차량번호/상호로 검색)</td>
          <td width="9%" class='title'>최근주행거리</td>
			<td width="*" align="left">&nbsp;&nbsp;<input class="whitetext" type="text" name="last_dist" value="" size="10" class=num style="text-align: right;"readonly>&nbsp;km</td>
			<td width="7%" class='title'>최근등록일</td>
			<td width="9%" align="left">&nbsp;&nbsp;<input class="whitetext" type="text" name="last_serv_dt" value="" size="10" readonly>&nbsp;</td>    
        </tr>
     		
      </table></td>
    </tr> 
     
    	<tr id=tr_acct3_<%=j%>_2 style='display:<%if( j < vt_i_size1 && !cd_bean.getAcct_code().equals("00019") ){%>table-row<%}else{%>none<%}%>'>
		<td colspan="2" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="10%" class='title'>사유</td>
					<td width="33%">&nbsp;
						<select name="o_cau" >
							<option value="">--선택--</option>
						<%for(int i = 0 ; i < c_size ; i++){
								CodeBean code = codes[i];	%>
							<option value='<%=code.getNm_cd()%>' <%if(ht_o_cau.equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
						<%}%>
						</select>
						&nbsp;*업무용인 경우 선택안해도 됨.
					
					<td width="9%" class='title'>주유량</td>
					<td width="*">&nbsp;
						<input type='text' size='7' class='num'  value="<%=ht_oil_liter%>" name='oil_liter' >&nbsp;L<br>
						&nbsp;*업무용인 경우 필수 (소숫점세자리까지 입력가능)		
					</td>
					<td width="7%" class='title'>주행거리</td>
					<td width="9%">&nbsp;
						<input type='text' size='6' class='num'  name='tot_dist' value='<%=ht_tot_dist%>' >&nbsp;km		
					</td>
				</tr>	
			</table>
		</td>
	</tr>
	
          
     <tr id=tr_acct3_<%=j%>_3 style='display:<%if( j < vt_i_size1 && !cd_bean.getAcct_code().equals("00019") ){%>table-row<%}else{%>none<%}%>'>
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
		          <td width="10%" class='title'>차량이용자</td>
		          <td width="33%">&nbsp;
		       		   <input type='text' size='30' class='text'  name='call_t_nm'  value="<%=ht_call_t_nm%>">	                
		          </td>
		         <td width="9%" class='title'>연락처</td>
		         <td width="*">&nbsp;
		         	<input type='text' size='30' class='text'  name='call_t_tel'  value="<%=ht_call_t_tel%>">
		         	<a href="javascript:CarMgr_search('<%=j%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
		          </td>
		        </tr>	
      		</table>
      	</td>
    </tr>      
   
    <tr id=tr_acct3_<%=j%>_97 style='display:<%if( j < vt_i_size1 && cd_bean.getAcct_code().equals("00019") ){%>table-row<%}else{%>none<%}%>'>
    	<td colspan="2" >
    		<table border="0" cellspacing="0" cellpadding="0" width='100%'>
        		<tr>
        			<td class="line">
	        			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        			<tr>
			          			<td width="10%" class='title'>금액</td>
			          			<td>&nbsp;
			            			<input name="doc_amt" class="num" value="<%=Util.parseDecimal(ht_doc_amt)%>" size="12" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value);'>원
			            		</td>
			            	</tr>
			            </table>
			        </td>    		
        		</tr>		         
      		</table>
      	</td>
    </tr>  
       
    <tr id=tr_acct3_<%=j%>_98 style='display:<%if( j < vt_i_size1 ){%>table-row<%}else{%>none<%}%>'>
    	<td colspan="2" >
    		<table border="0" cellspacing="0" cellpadding="0" width='100%'>
        		<tr>
        			<td class="line">
	        			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        			<tr>
			          			<td width="10%" class='title'>적요</td>
			          			<td>&nbsp;
			            			<textarea name="acct_cont" cols="90" rows="2" class="text"><%=ht_acct_cont%></textarea> (한글40자이내)
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
    <tr id=tr_acct99 style="display:<%if(cd_bean.getAcct_code().equals("00001") || cd_bean.getAcct_code().equals("00002") || cd_bean.getAcct_code().equals("00003") || cd_bean.getAcct_code().equals("")){%>table-row<%}else{%>none<%}%>">
    	<td colspan="2" class="line">
      		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td colspan='4'>
						<div style="vertical-align:middle; padding-top:6px;">
							&nbsp;<font color="red">※ "혼자" 선택시 카드소유자나 등록자가 아닌 "실제사용자"가 사용한 것으로 등록됨. 다른직원의 전표를 대신 등록하는 경우 반드시 "선택"을 누른 후 아래에서 사용자를 변경바람.</font>
						</div>
					</td>
				</tr>
        		<tr>
          			<td width="10%" class='title'>비용분담</td>                                                                                                                                                                                                          
          			<td width="40%" align='left'>&nbsp;
						<input type='radio' name="acct_code_s" value='1' onClick="javascript:cng_input5(this.value)" <%if(cd_bean.getUser_su().equals(""))%>checked<%%>>혼자&nbsp;&nbsp;
						<input type='radio' name="acct_code_s" value='2' onClick="javascript:cng_input5(this.value)" >파트너&nbsp;&nbsp;
						<input type='radio' name="acct_code_s" value='3' onClick="javascript:cng_input5(this.value)" <%if(!cd_bean.getUser_su().equals(""))%>checked<%%>>선택&nbsp;&nbsp;
            			<input name="user_su" type="text" class="text" value ="<%if(cd_bean.getUser_su().equals("")){%>1<%}else{%><%=cd_bean.getUser_su()%><%}%>" size="3" onBlur="javascript:cng_input11();">명&nbsp;       		  
            			<input name="user_cont" type="<%if(!cd_bean.getUser_cont().equals("")){%>text<%}else{%>hidden<%}%>" class="text"  value="<%=cd_bean.getUser_cont()%>" size="10">
					</td>
          			<td width="13%" class='title'>개인별 지출금액</td>
              		<td width="*">&nbsp;
			     		<input type="radio" name="user_Rdio" value="0" onClick="javascript:cng_input1(this.value)" <%if(reg_user_id.equals(""))%>checked<%%>> 1/n
			      		<input type="radio" name="user_Rdio" value="1" onClick="javascript:cng_input1(this.value)">금액 직접입력
			      		<input type="hidden"  name="buy_a_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
					</td>
          		</tr>
          	</table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr>
        <td><label><i class="fa fa-check-circle"></i> 부서/성명/금액 입력 </label></td>
        <%-- <td align="right">
            <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
      		<a id="submitLink" href="javascript:Save()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp;
      	    <%}%>	
      	    <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
      	</td> --%>
    </tr>
    
  	<tr  id=tr_acct101 style="display:<%if((cd_bean.getAcct_code().equals("00001") || cd_bean.getAcct_code().equals("00002") || cd_bean.getAcct_code().equals("00003"))/*  && !cd_bean.getUser_su().equals("") */){%>table-row<%}else{%>none<%}%>" >
		<td colspan="2">
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
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
                        <%	Vector vts1 = CardDb.getCardDocUserList(cardno, buy_id, "1");
							int vt_size1 = vts1.size();
							
							if ( vt_size1 % 2 == 1 ) {
							  chk = "1";
							}
						%>
							
						<%for(int j = 0 ; j < vt_size1 ; j+=2){
							
								Hashtable ht = (Hashtable)vts1.elementAt(j);
								Hashtable ht2 = new Hashtable();
								if(j+1 < vt_size1){
										ht2 = (Hashtable)vts1.elementAt(j+1);
										
								}%>								
								
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
          								<option value='<%=dept.getCode()%>' <%if(String.valueOf(ht.get("DEPT_ID")).equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
          									<%}%>
        							</select>
        						</td>
								<td align="center">
									<input name="user_case_id" type="hidden" value='<%=ht.get("DOC_USER")%>'>
									<input name="r_dept_id" type="hidden">
									<input name="user_nm" type="text" readonly class="text" value='<%=ht.get("USER_NM")%>' size="14" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+1%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="<%=Util.parseDecimal(String.valueOf(ht.get("DOC_AMT")))%>" size="14" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								</td>
					           	<td align="center"><%=j+2%></td>
					            <%if(j+1 < vt_size1){%>
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
          								<option value='<%=dept.getCode()%>' <%if(String.valueOf(ht2.get("DEPT_ID")).equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
          									<%}%>
        							</select>
        						</td>
								<td align="center">
									<input name="user_case_id" type="hidden" value='<%=ht2.get("DOC_USER")%>'>
									<input name="r_dept_id" type="hidden">
									<input name="user_nm" type="text" readonly class="text" value='<%=ht2.get("USER_NM")%>' size="14" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+2%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="<%=Util.parseDecimal(String.valueOf(ht2.get("DOC_AMT")))%>" size="14" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								</td>
								<% } else  { %>	
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
									<input name="user_nm" type="text" readonly class="text" size="14" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+2%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="" size="14" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								</td>
								<% }  %>
							</tr>								
							<%}%>		
						<!-- 추가 -->						
						<%	if 	(chk.equals("1"))  {
									 vt_size1 = vt_size1 + 1;
							}	
						//	for( int j = vt_size1 ; j < 100 ; j+=2){
							for( int j = vt_size1 ; j < vt_acar_size; j+=2){
							
						
						%>
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
									<input name="user_nm" type="text" readonly class="text" size="14" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+1%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="" size="14" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
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
									<input name="user_nm" type="text" readonly class="text" size="14" style='IME-MODE: active' onKeyDown="javasript:enter2('user_case_id', <%=j+2%>)">
	    						</td>								
								<td align="center">
									<input name="money" class="text" value="" size="14" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue();'>
								</td>
							</tr>									
							<%}%>
							<tr>
								<td colspan="7" class='title'>누계</td>
								<td align="center">
									<input name="txtTot" class="text" value="" style="text-align:right;" size="14" readonly>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
	</tr>         	
	<tr><td class=h></td></tr><tr><td class=h></td></tr>
</table>

</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	Keyvalue();
//-->
</script>
</body>
</html>
