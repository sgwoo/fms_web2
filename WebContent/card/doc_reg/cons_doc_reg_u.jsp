<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.bill_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String car_no 	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String cons_no 	= request.getParameter("cons_no")==null?"":request.getParameter("cons_no");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	
	//전표정보
	CardDocBean cd_bean = CardDb.getCardDocCons(car_no, cons_no, seq);
	
	cardno = cd_bean.getCardno();
	buy_id = cd_bean.getBuy_id();
	//거래처정보
	Hashtable vendor = new Hashtable();
	if(!cd_bean.getVen_code().equals("")){
		vendor = neoe_db.getVendorCase(cd_bean.getVen_code());
	}
	
	//거래처변경자들
	Hashtable ven_reg = neoe_db.getTradeHisRegIds(cd_bean.getVen_code(), cd_bean.getReg_dt());//-> neoe_db 변환
	
	//장기계약 리스트 조회
	Hashtable l_cont = CardDb.getLRent(cd_bean.getRent_l_cd());
		
	String acct_code 	= cd_bean.getAcct_code();
	String acct_code_g 	= cd_bean.getAcct_code_g();
	String acct_code_g2 = cd_bean.getAcct_code_g2();
	String acct_cont 	= cd_bean.getAcct_cont()==null?"":cd_bean.getAcct_cont();
	String firm_nm 		= String.valueOf(l_cont.get("FIRM_NM"))==null?"":String.valueOf(l_cont.get("FIRM_NM"));
	String item_name	= cd_bean.getItem_name();
	String doc_acct_cont = "";
	
	String chk="0";
	
	if(!item_name.equals("") && cd_bean.getItem_name().indexOf("(")!=-1){
		item_name 	= cd_bean.getItem_name().substring(0, cd_bean.getItem_name().indexOf("("));
	}
	
	
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
	String user_su 		= cd_bean.getUser_su();
	String user_cont	= cd_bean.getUser_cont();
	String buy_user_nm 	= c_db.getNameById(cd_bean.getBuy_user_id(), "USER");
	
		//복리후생비
		if(acct_code.equals("00001")){
			if(acct_code_g.equals("1")      && acct_code_g2.equals("1"))	doc_acct_cont = "조식대:"+acct_cont;
			else if(acct_code_g.equals("1") && acct_code_g2.equals("2"))	doc_acct_cont = "중식대:"+acct_cont;
			else if(acct_code_g.equals("1") && acct_code_g2.equals("3"))	doc_acct_cont = "석식대:"+acct_cont;
			else if(acct_code_g.equals("2") && acct_code_g2.equals("4"))	doc_acct_cont = "회사전체모임:"+acct_cont;
			else if(acct_code_g.equals("2") && acct_code_g2.equals("5"))	doc_acct_cont = "부서별정기모임:"+acct_cont;
			else if(acct_code_g.equals("2") && acct_code_g2.equals("6"))	doc_acct_cont = "부서별부정기회식:"+acct_cont;
			else if(acct_code_g.equals("2") && acct_code_g2.equals("15"))	doc_acct_cont = "동호회:"+acct_cont;
			else if(acct_code_g.equals("15") )								doc_acct_cont = "경조사:"+acct_cont;
			else if(acct_code_g.equals("30") )								doc_acct_cont = "포상휴가:"+acct_cont;
			else 							 								doc_acct_cont = acct_cont;

/*			
			else if(acct_code_g.equals("3") && acct_code_g2.equals("7"))	doc_acct_cont = "커피:"+acct_cont;
			else if(acct_code_g.equals("3") && acct_code_g2.equals("8"))	doc_acct_cont = "음료:"+acct_cont;
			else if(acct_code_g.equals("3") && acct_code_g2.equals("9"))	doc_acct_cont = "약품:"+acct_cont;
			else if(acct_code_g.equals("3") && acct_code_g2.equals("10"))	doc_acct_cont = acct_cont;
*/		
		//차량유류비
		}else if(acct_code.equals("00004")){
			if(acct_code_g.equals("13"))			doc_acct_cont = "가솔린";
			else if(acct_code_g.equals("4"))		doc_acct_cont = "디젤";
			else if(acct_code_g.equals("5"))		doc_acct_cont = "LPG";
			else if(acct_code_g.equals("27"))		doc_acct_cont = "전기차충전";	//전기차충전 추가
			
			if(acct_code_g2.equals("11"))			doc_acct_cont = doc_acct_cont+"-"+acct_cont;
			else if(acct_code_g2.equals("12"))		doc_acct_cont = doc_acct_cont+"-"+acct_cont;
			else if(acct_code_g2.equals("13"))		doc_acct_cont = doc_acct_cont+"-"+acct_cont;
			
		//	if(!cd_bean.getRent_l_cd().equals("")) 	doc_acct_cont = doc_acct_cont+"-"+firm_nm;
		//	else									doc_acct_cont = doc_acct_cont+"("+buy_user_nm+")";
			
		//차량정비비
		}else if(acct_code.equals("00005")){
			
			if(acct_code_g.equals("6"))				doc_acct_cont = "일반정비:"+acct_cont;
			else if(acct_code_g.equals("7"))		doc_acct_cont = "자동차검사:"+acct_cont;
	//		else if(acct_code_g.equals("8"))		doc_acct_cont = "점검기록부:"+acct_cont;
			else if(acct_code_g.equals("18"))		doc_acct_cont = "번호판대금:"+acct_cont;		
			else if(acct_code_g.equals("21"))		doc_acct_cont = "재리스정비:"+acct_cont;	
			else if(acct_code_g.equals("22"))		doc_acct_cont = acct_cont;	
					
		
		//	if(!buy_user_nm.equals("")) 			doc_acct_cont = doc_acct_cont+"("+buy_user_nm+")";
		
		//사고수리비
		}else if(acct_code.equals("00006")){
		
			doc_acct_cont = acct_cont;
		
		//	if(!buy_user_nm.equals("")) 			doc_acct_cont = doc_acct_cont+"("+buy_user_nm+")";
		
		//여비교통비
		}else if(acct_code.equals("00003")){
		
			//출장비
			if(acct_code_g.equals("9"))				doc_acct_cont = "출장비:"+acct_cont;
			//교통비
			else if(acct_code_g.equals("12"))		doc_acct_cont = "기타교통비:"+acct_cont;
			//하이패스
			else if(acct_code_g.equals("20"))		doc_acct_cont = "하이패스:"+acct_cont;
				//하이패스
			else if(acct_code_g.equals("32"))		doc_acct_cont = "제안참석:"+acct_cont;
		
		//접대비
		}else if(acct_code.equals("00002")){
		
			//식대
			if(acct_code_g.equals("11"))			doc_acct_cont = "식대:"+acct_cont;
			//경조사
			else if(acct_code_g.equals("12"))		doc_acct_cont = "경조사:"+acct_cont;
			//기타
			else if(acct_code_g.equals("14"))		doc_acct_cont = acct_cont;
		
		//통신비
		}else if(acct_code.equals("00009")){
													doc_acct_cont = "통신비:"+acct_cont;
		
		//대여사업차량
		}else if(acct_code.equals("00016")){
			if(acct_code_g.equals("19"))			doc_acct_cont = "차량등록세:"+acct_cont;
		
		//리스사업차량
		}else if(acct_code.equals("00017")){
			if(acct_code_g.equals("19"))			doc_acct_cont = "차량등록세:"+acct_cont;
		
		}else{
		
			doc_acct_cont = acct_cont;
		
		}

		if(!user_cont.equals("")) 		doc_acct_cont = doc_acct_cont+" "+user_cont;
		if(!user_su.equals("")) 		doc_acct_cont = doc_acct_cont+"("+user_su+"명)";
		
		
	String car_su = "1";
		
	Vector vt_item = CardDb.getCardDocItemList(cardno, buy_id); 
 	int vt_i_size1 = vt_item.size();
 	
 	if ( vt_i_size1 > 0) {
 	    car_su = Integer.toString(vt_i_size1);
 	} 	

	String file_path = cd_bean.getFile_path();
//	file_path = file_path.substring(0,4);

//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------

	int size = 0;
	
	String content_code = "CARD_DOC";
	String content_seq  = cardno+buy_id;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	
	String file_type1 = "";
	String seq1 = "";
	String file_name1 = "";
	
	for(int j=0; j< attach_vt.size(); j++){
		Hashtable aht = (Hashtable)attach_vt.elementAt(j);   
		
		if((content_seq).equals(aht.get("CONTENT_SEQ"))){
			file_name1 = String.valueOf(aht.get("FILE_NAME"));
			file_type1 = String.valueOf(aht.get("FILE_TYPE"));
			seq1 = String.valueOf(aht.get("SEQ"));
			
		}
	}	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//승인
	function Save_app(){
		var fm = document.form1;
		if(fm.cardno.value == '')	{	alert('카드번호를 입력하십시오.'); 	fm.cardno.focus(); 		return; }
		if(fm.buy_dt.value == '')	{	alert('거래일자를 선택하십시오.'); 	fm.buy_dt.focus(); 		return; }
		if(fm.buy_s_amt.value == '0'){	alert('매입금액을 입력하십시오.'); 	fm.buy_s_amt.focus(); 	return; }
		if(fm.buy_amt.value == '0'){	alert('매입금액을 입력하십시오.'); 	fm.buy_amt.focus(); 	return; }		
		if(fm.ven_name.value == ''){	alert('거래처를 입력하십시오.'); 	fm.ven_name.focus(); 	return; }
		if(fm.buy_v_amt.value != '0' && fm.ven_code.value == ''){	alert('거래처를 조회하십시오?'); return; }
		if(fm.user_nm.value == '' || fm.buy_user_id.value == ''){	alert('사용자를 검색하십시오.'); return; }	
		
		//접대비를 제외한
		if(fm.acct_code[1].checked == false ){
			if(fm.ven_st[0].checked == false && fm.ven_st[1].checked == false  && fm.ven_st[2].checked == false  && fm.ven_st[3].checked == false)
				{ alert('과세유형을 선택하십시오.'); return;}
			
			if(fm.ven_st[0].checked == true && fm.buy_v_amt.value == '0'){	alert('일반과세자입니다. 부가세를 확인해주세요.'); return; }	
			
			if(fm.ven_st[1].checked == true || fm.ven_st[2].checked == true ) {
			   if ( fm.buy_v_amt.value != '0' ) {		  
					alert('간이과세나 면세입니다. 부가세를 확인해주세요.'); 
					return;
			   }	
			}			
		}	
	
		//복리후생비
		if(fm.acct_code[0].checked == true 
			&& fm.acct_code_g[0].checked == false  && fm.acct_code_g[1].checked == false  && fm.acct_code_g[2].checked == false && fm.acct_code_g[3].checked == false && fm.acct_code_g[4].checked == false
			&& fm.acct_code_g2[0].checked == false && fm.acct_code_g2[1].checked == false && fm.acct_code_g2[2].checked == false 
			&& fm.acct_code_g2[3].checked == false && fm.acct_code_g2[4].checked == false && fm.acct_code_g2[5].checked == false && fm.acct_code_g2[6].checked == false)
			{ alert('구분을 선택하십시오.'); return;}
			
		//접대비		
		if(fm.acct_code[1].checked == true 
			&& fm.acct_code_g[17].checked == false && fm.acct_code_g[18].checked == false && fm.acct_code_g[19].checked == false)
			{ alert('구분을 선택하십시오.'); return;}
			
		//여비교통비
		if(fm.acct_code[2].checked == true 
			&& fm.acct_code_g[13].checked == false && fm.acct_code_g[14].checked == false && fm.acct_code_g[15].checked == false && fm.acct_code_g[16].checked == false)
			{ alert('구분을 선택하십시오.'); return;}
			
		//차량유류비
		if(fm.acct_code[3].checked == true 
			&& fm.acct_code_g[5].checked == false  && fm.acct_code_g[6].checked == false  && fm.acct_code_g[7].checked == false
			&& fm.acct_code_g2[7].checked == false && fm.acct_code_g2[8].checked == false && fm.acct_code_g2[9].checked == false)
			{ alert('구분을 선택하십시오.'); return;}
			
		//차량정비비
		if(fm.acct_code[4].checked == true 
			&& fm.acct_code_g[8].checked == false && fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false && fm.acct_code_g[12].checked == false )
			{ alert('구분을 선택하십시오.'); return;}
			
		//사고수리비&사무용품비&소모품비&통신비&도서인쇄비&지급수수료&비품&선급금
		if((fm.acct_code[5].checked == true || fm.acct_code[6].checked == true || fm.acct_code[7].checked == true || fm.acct_code[8].checked == true
				|| fm.acct_code[9].checked == true || fm.acct_code[10].checked == true || fm.acct_code[11].checked == true || fm.acct_code[12].checked == true || fm.acct_code[13].checked == true)
			&& fm.acct_cont[0].value == '')
			{ alert('적요를 입력하십시오.'); return;}
		
		//유류, 정비, 사고는 반드시 차량 조회하여 car_mng_id 구한다.
		if (fm.acct_code[3].checked == true || fm.acct_code[4].checked == true || fm.acct_code[5].checked == true || fm.acct_code[17].checked == true || fm.acct_code[18].checked == true) {
		   if (fm.acct_code_g[10].checked == true || fm.acct_code_g[12].checked == true ) {
		   } else {
		   	if ( fm.item_code[0].value == '') { alert('차량을 검색하여 선택하십시오.'); return;}
		   }	
		}		
			//통신비
		if(fm.acct_code[7].checked == true 
			&& fm.acct_code_g[20].checked == false && fm.acct_code_g[21].checked == false)
			{ alert('구분을 선택하십시오.'); return;}
				
				
		//적요 글자수 체크
	//	if(fm.doc_acct_cont.value != '' && !max_length(fm.doc_acct_cont.value,80)){	
		if(fm.doc_acct_cont.value == ''){	
		//	alert('현재 적요 길이는 '+get_length(fm.doc_acct_cont.value)+'자(공백포함) 입니다.\n\n적요는 한글40자/영문80자까지 입력이 가능합니다.'); return; } 
			alert('전표적요를 입력하세요..'); return; 
		} 						

		//전표일자 체크
		if(getRentTime('m', fm.buy_dt.value, <%=AddUtil.getDate()%>) > 3){ 
			if(!confirm('입력하신 전표일자가 석달이상 차이납니다.\n\n전표를 입력 하시겠습니까?'))			
				return;
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
			fm.user_cont.value	=	strUserCnt;		
		}
				
			    //복리후생비인 경우 부서원 없이 금액 입력 못함. - 식대/ 중식 에 한함
      		//  if(fm.acct_code[0].checked == true && fm.acct_code_g[0].checked == true && fm.acct_code_g2[1].checked == true  ){
     		//   if(fm.acct_code[0].checked == true && fm.acct_code_g[0].checked == true   ){
       		if(fm.acct_code[0].checked == true   ){ 	   
        	  	if(fm.user_su.value == ''){ alert("인원수를 등록하셔야 합니다. 다시 확인 해주세요"); return; }
        	   
        	  	if ( toInt(fm.user_su.value) == false ) { alert("인원수는 숫자여야 합니다. 다시 확인 해주세요"); return; }
        	    
        	  	if(fm.txtTot.value == '' || fm.txtTot.value == '0' ){ alert("금액을 등록하셔야 합니다. 다시 확인 해주세요"); return; }		
        	  	  
           	  	if(inCnt>0){
					for(i=0; i<inCnt ; i++){
					   strDept_id =  fm.dept_id[i].value;
					   strMoney =  fm.money[i].value;
					   
					   totMoney += toInt(parseDigit(fm.money[i].value));
					   						   
					   if (strDept_id == '' && parseInt(strMoney) > 0 ) {
					       alert('사용자를 선택하셔야 금액이 입력 가능합니다!!!.'); 
					       return;
					   }    
					}
					
					if ( totMoney != toInt(parseDigit(fm.buy_amt.value))  ) {
					 	  alert('참가인원과 금액을  확인하세요!!.'); 
					      return;				 
					}	
							
			}	
		}					
				
				
		
					
		//개인별 지출금액 합계 점검
		if(fm.txtTot.value != '' && fm.txtTot.value != '0' && fm.txtTot.value != fm.buy_amt.value){ alert("합계와 누계가 맞지 않습니다. 다시 확인 해주세요"); return; }
		
						
		if(confirm('승인하시겠습니까?')){	
		
							
			fm.action='doc_app_case_step.jsp';		
			
			fm.target='i_no';
//			fm.target='CardDocView';						
			fm.submit();
		}
	}

	//삭제
	function Del_app(){
		var fm = document.form1;
		if(confirm('삭제하시겠습니까?')){					
		if(confirm('진짜로 삭제하시겠습니까?')){					
		if(confirm('정말 삭제하시겠습니까?')){									
			fm.action='doc_app_case_del.jsp';		
			fm.target='i_no';
//			fm.target='CardDocView';			
			fm.submit();
		}}}
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
		//접대비가 아니고, 일반과세인 경우
		if(fm.acct_code[1].checked == false && fm.ven_st[0].checked == true){
			fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));		
		}else{
			fm.buy_s_amt.value 		= fm.buy_amt.value;
			fm.buy_v_amt.value 		= 0;									
		}			
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
		//접대비가 아니고, 일반과세인 경우
		if(fm.acct_code[1].checked == false && fm.ven_st[0].checked == true){
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_s_amt.value)) * 0.1 );
		}else{
			fm.buy_v_amt.value = 0;				
		}
		set_buy_amt();			
	}	
	
	//네오엠조회-신용카드
	function Neom_search(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == 'cardno')	fm.t_wd.value = fm.cardno.value;
		window.open("about:blank",'Neom_search','scrollbars=yes,status=no,resizable=yes,width=600,height=500,left=250,top=250');		
		fm.action = "../doc_reg/neom_search.jsp";
		fm.target = "Neom_search";
		fm.submit();		
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
		window.open("about:blank",'Neom_search','scrollbars=yes,status=no,resizable=yes,width=600,height=500,left=250,top=250');		
		fm.action = "../card_mng/neom_search.jsp";
		fm.target = "Neom_search";
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
		if(fm.ven_name.value != '')	fm.t_wd.value = fm.ven_name.value;		
		window.open("../doc_reg/vendor_list2.jsp?idx="+idx+"&t_wd="+fm.t_wd.value, "VENDOR_LIST", "left=300, top=300, width=700, height=400, scrollbars=yes");		
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
			if(fm.acct_code_g[8].checked == false && fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false && fm.acct_code_g[12].checked == false )
			{	alert('구분을 선택하십시오.'); 	fm.buy_dt.focus(); 		return; }
		}
					
		if(fm.item_name[idx1].value != ''){	fm.t_wd.value = fm.item_name[idx1].value;		}
		else{ 							alert('조회할 차량번호/상호를 입력하십시오.'); 	fm.item_name.focus(); 	return;}
				
		if ( fm.acct_code[4].checked == true ) {
			if (fm.acct_code_g[8].checked 	== true  || fm.acct_code_g[11].checked 	== true ) { //일반정비비, 재리스 정비비
				window.open("../doc_reg/service_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value+"&buy_dt="+fm.buy_dt.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			
		    } else {
		    	window.open("../doc_reg/rent_search.jsp?t_wd="+fm.t_wd.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			    
		    }
		} else if ( fm.acct_code[5].checked == true ) {
			window.open("../doc_reg/service_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value+"&buy_dt="+fm.buy_dt.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			
	    } else {		
			window.open("../doc_reg/rent_search.jsp?t_wd="+fm.t_wd.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");		
		}
			
	}
	
	function Rent_enter(idx1) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Rent_search(idx1);
	}	
	
	
		
	//직원조회
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = fm.user_nm[0].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=250,top=250');		
		fm.action = "../card_mng/user_search.jsp?nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
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
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');		
		fm.action = "../card_mng/user_search.jsp?dept_id="+fm.dept_id[idx-1].value+"&nm="+nm+"&idx="+idx;
		fm.target = "User_search";
		fm.submit();		
	}
	function enter2(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') User_search2(nm, idx);
	}	
	
	//계정과목 안내문
	function help(){
		var fm = document.form1;
		var SUBWIN="../doc_reg/help.jsp";	
		window.open(SUBWIN, "help", "left=350, top=350, width=400, height=300, scrollbars=yes, status=yes");
	}
	
	function cng_vs_input(){
		var fm = document.form1;
		
		//접대비가 아니고, 일반과세인 경우
		if(fm.acct_code[1].checked == false && fm.ven_st[0].checked == true){
			fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));		
		}else{
			fm.buy_s_amt.value 		= fm.buy_amt.value;
			fm.buy_v_amt.value 		= 0;									
		}					
	}	
	
		//계정과목 선택시
	function cng_input(){
		var fm = document.form1;
		
		tot_buy_amt();
		
		if(fm.acct_code[0].checked == true){ 		//복리후생비
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
			fm.acct_code_g[0].checked 	= true;
			fm.acct_code_g2[1].checked 	= true;
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
			
			<%}%>	
		}else if(fm.acct_code[1].checked == true){ 	//접대비
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
			fm.acct_code_g[16].checked 	= true;  //식대
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
			
			<%}%>	
		}else if(fm.acct_code[2].checked == true){ 	//여비교통비
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
			fm.acct_code_g[13].checked 	= true; //출장비
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
			
			<%}%>	
		}else if(fm.acct_code[3].checked == true){ 	//차량유류대
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
			fm.acct_code_g[5].checked 	= true;
			fm.acct_code_g2[7].checked 	= true;
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
			
			<%}%>	
		}else if(fm.acct_code[4].checked == true){ 	//차량정비비
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
			
	//		fm.acct_code_g[7].checked 	= true;
			if(fm.acct_code_g[8].checked == true){ 
				tr_acct_plus.style.display	= '';
				tr_acct3_3.style.display	= '';	
			} else {
				tr_acct_plus.style.display	= 'none';
				tr_acct3_3.style.display	= 'none';	
			}	
			
			<%for(int i=1;i < 19 ;i++){%>
				if( toInt(fm.car_su.value) > <%=i%>){
					tr_acct3_<%=i%>_1.style.display	= '';
					tr_acct3_<%=i%>_3.style.display	= '';
					tr_acct3_<%=i%>_98.style.display	= '';
					
				}else{
					tr_acct3_<%=i%>_1.style.display	= 'none';
					tr_acct3_<%=i%>_3.style.display	= 'none';
					tr_acct3_<%=i%>_98.style.display	= 'none';
				
				}
			<%}%>	
			
		}else if(fm.acct_code[5].checked == true){ 	//사고수리비
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
			tr_acct3_3.style.display	= '';	
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
		
			<%}%>	
		
		}else if(fm.acct_code[7].checked == true){ 	//통신비
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
		//	tr_acct102.style.display 	= 'none';
			tr_acct_plus.style.display	= 'none';
			fm.acct_code_g[20].checked 	= true;  //개별	
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
		
			<%}%>	
		}else if(fm.acct_code[15].checked == true || fm.acct_code[16].checked == true){ 	//대여/리스사업차량
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
		//	tr_acct102.style.display 	= 'none';
			tr_acct_plus.style.display	= 'none';
			fm.acct_code_g[22].checked 	= true;
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
		
			<%}%>	
		}else if(fm.acct_code[17].checked == true || fm.acct_code[18].checked == true){ 	//운반비
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
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';			
			
			<%}%>			
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
			tr_acct98.style.display		= '';
			tr_acct99.style.display		= 'none';
			tr_acct101.style.display 	= 'none';
		
			tr_acct_plus.style.display	= 'none';
			<%for(int i=1;i<19 ;i++){%>
				tr_acct3_<%=i%>_1.style.display	= 'none';
				tr_acct3_<%=i%>_3.style.display	= 'none';
				tr_acct3_<%=i%>_98.style.display= 'none';
		
			<%}%>	
		}
	}
	

	//복리후생비 구분 선택시
	function cng_input2()
	{
		var fm = document.form1;
		if(fm.acct_code_g[0].checked == true){ //식대
			fm.acct_code_g2[1].checked 	= true;
			tr_acct1_1.style.display	= '';
			tr_acct1_2.style.display	= 'none';
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';
			tr_acct101.style.display 	= '';
		
		}
		if(fm.acct_code_g[1].checked == true){ //복지비
			fm.acct_code_g2[3].checked 	= true;
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= '';			
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= 'none';			
			tr_acct101.style.display 	= '';
	
		}
		if(fm.acct_code_g[2].checked == true){ //경조사
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= 'none';			
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';			
			tr_acct101.style.display 	= '';
			
		}
		if(fm.acct_code_g[3].checked == true){ //기타
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= 'none';			
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';			
			tr_acct101.style.display 	= '';
			
		}
		if(fm.acct_code_g[4].checked == true){ //포상휴가
			tr_acct1_1.style.display	= 'none';
			tr_acct1_2.style.display	= 'none';			
			tr_acct98.style.display 	= '';
			tr_acct99.style.display 	= '';			
			tr_acct101.style.display 	= '';
			
		}
	}	

	//복리후생비 회식비 구분 선택시	
	function cng_input22()
	{
		var fm = document.form1;
				
		tr_acct98.style.display 	= '';
		tr_acct99.style.display 	= '';					
		tr_acct101.style.display 	= '';	
	}
	
	//통신비 구분 선택시	
	function cng_input7()
	{
		
		var fm = document.form1;		
		if(fm.acct_code_g[20].checked == true){			//개별			
			tr_acct99.style.display 	= '';					
			tr_acct101.style.display 	= '';			
		}
		if(fm.acct_code_g[21].checked == true){			//공통
			tr_acct99.style.display 	= 'none';					
			tr_acct101.style.display 	= 'none';	
		
		}
		
	}
	
	//정비비 구분 선택시
	function cng_input4()
	{
		var fm = document.form1;
		if(fm.acct_code_g[8].checked == true){ //일반정비
			tr_acct_plus.style.display	= '';
			tr_acct3_1.style.display	= '';
			tr_acct3_3.style.display	= '';	
				
		}
		if(fm.acct_code_g[9].checked == true){ //정기검사
			tr_acct_plus.style.display	= 'none';
			tr_acct3_1.style.display	= '';
			tr_acct3_3.style.display	= 'none';
			
		}
	
		if(fm.acct_code_g[10].checked == true){ //번호판
			tr_acct_plus.style.display	= 'none';
			tr_acct3_1.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';
			
		}
		if(fm.acct_code_g[11].checked == true){ //재리스정비
			tr_acct_plus.style.display	= 'none';
			tr_acct3_1.style.display	= '';
			tr_acct3_3.style.display	= 'none';
			
		}
		
		if(fm.acct_code_g[12].checked == true){ //기타
			tr_acct_plus.style.display	= 'none';
			tr_acct3_1.style.display	= 'none';
			tr_acct3_3.style.display	= 'none';
			
		}
	}		
	
	
	//개인당 지출 금액(1/n:0, 금액직접입력:1)
	function cng_input1()
	{
		var fm 		= document.form1;
		var inCnt	= toInt(fm.user_su.value);
		var inTot	= toInt(parseDigit(fm.buy_amt.value));
		var innTot	= 0;
		
		if(inCnt > 80){	alert('1/n 입력은 최대 80인까지 입니다.'); return;}
		
		if(fm.user_Rdio[0].checked == true && inCnt > 0 && toInt(parseDigit(fm.buy_amt.value)) > 0)
		{
			var inAmt = Math.round(toInt(parseDigit(fm.buy_amt.value)) / inCnt);			

			for(i=0; i<inCnt ; i++){
				fm.money[i].value = parseDecimal(inAmt);
				innTot += inAmt;
			}
			for(i=inCnt; i<80 ; i++){
				fm.money[i].value = '0';
			}
			
			if(inTot > innTot) 	fm.money[0].value 		= parseDecimal(toInt(parseDigit(fm.money[0].value)) 	  + (inTot-innTot));
			if(inTot < innTot) 	fm.money[inCnt-1].value = parseDecimal(toInt(parseDigit(fm.money[inCnt-1].value)) + (inTot-innTot));
			
			fm.txtTot.value = fm.buy_amt.value;
		}
		
		if(fm.user_Rdio[1].checked == true)
		{
			for(i=0; i<80 ; i++){
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
		
		for(i=0; i<80 ; i++){
			innTot += toInt(parseDigit(fm.money[i].value));
		}
		
		<%if(cd_bean.getAcct_code().equals("00001") || cd_bean.getAcct_code().equals("00002") || cd_bean.getAcct_code().equals("00003")){%>
		fm.txtTot.value = parseDecimal(innTot);
		<%}%>
	}
	
	//카드전표 카드변경
	function doc_card_change(){
		var fm = document.form1;
		window.open("about:blank",'CardChange','scrollbars=yes,status=no,resizable=yes,width=600,height=200,left=250,top=250');		
		fm.action = "card_change.jsp";
		fm.target = "CardChange";
		fm.submit();		
	}
	
	function CardDocHistory(ven_code, cardno, buy_id){
		var fm = document.form1;
		window.open("../doc_reg/vendor_carddoc_nowyear_history.jsp?ven_code="+ven_code+"&cardno="+cardno+"&buy_id="+buy_id, "VENDOR_DOC_LIST", "left=10, top=10, width=950, height=600, scrollbars=yes");				
	}		
	
	function VendorHistory(ven_code){
		var fm = document.form1;
		window.open("../doc_reg/vendor_history.jsp?ven_code="+ven_code, "VENDOR_H_LIST", "left=10, top=10, width=1050, height=600, scrollbars=yes");				
	}
	
	//국세청과세유형조회
	function search_nts(){
		var fm = document.form1;
		fm.nts_yn.value='Y';
		window.open("https://teht.hometax.go.kr/websquare/websquare.html?w2xPath=/ui/ab/a/a/UTEABAAA13.xml", "NTS_SEARCH", "left=0, top=0, height=<%=s_height%>, width=<%=s_width%>, scrollbars=yes");
	}	


//팝업윈도우 열기
	function MM_openBrWindow(theURL,file_path,features) { //v2.0
			theURL = "https://fms3.amazoncar.co.kr/data/"+file_path+""+theURL;
		//	alert(theURL);
			window.open(theURL,'popwin_in1',features);
	}	
	
	
	function set_oil_price(){
		var fm = document.form1;		
		
			fm.oil_price.value 		= Math.round(toInt(parseDigit(fm.buy_amt.value)) / parseDigit(fm.oil_liter.value));		
		alert(fm.oilprice.value);
	}

	
			//스캔등록
function scan_reg(){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&cardno=<%=cardno%>&buy_id=<%=buy_id%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
}

//-->
</script>

</head>
<body onload="javascript:document.form1.buy_dt.focus();set_oil_price();">
<form action="" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="car_no" value="<%=car_no%>">
  <input type='hidden' name='cons_no' value='<%=cons_no%>'>
  <input type='hidden' name='nts_yn' value=''> 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 법인전표관리 > <span class=style5>전표승인</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr><tr><td class=h></td></tr>
	<tr><td class=line2 colspan=2></td></tr>
    <tr> 
      <td colspan="2" class="line">
          <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr>
              <td width="15%" class='title'>신용카드번호</td>
              <td width="85%">&nbsp;
                  <input name="cardno" type="text" class="whitetext" value="<%=cardno%>" size="30" readonly> 
                  (<%=buy_id%>)
              </td>
            </tr>
          </table>
      </td>
    </tr>	
    <tr>
	  <td class=h></td>
    <tr>
	  <td>&nbsp;&nbsp;&nbsp;
     <img src=/acar/images/center/arrow_ccdrj.gif align=absmiddle> : <%=c_db.getNameById(cd_bean.getReg_id(), "USER")%>  
     &nbsp;&nbsp; <img src=/acar/images/center/arrow_ccdri.gif align=absmiddle> : <%=AddUtil.ChangeDate2(cd_bean.getReg_dt())%>
     &nbsp;&nbsp; <img src=/acar/images/center/arrow_cjsjj.gif align=absmiddle> : <%=c_db.getNameById(cd_bean.getApp_id(), "USER")%>
     &nbsp;&nbsp; <img src=/acar/images/center/arrow_cjsji.gif align=absmiddle> : <%=AddUtil.ChangeDate2(cd_bean.getApp_dt())%> 
    </td></tr>       
    <tr>
	  <td class=h></td>
    <tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr>
      <td colspan="2" class=line>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td colspan="2" class='title'>거래일자</td>
          	<td width="85%">&nbsp;
		  	  <input name="buy_dt" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(cd_bean.getBuy_dt())%>" size="12" onBlur='javascript:this.value=ChangeDate2(this.value)' readonly></td>
          </tr>
       
          <tr>
          <td width="3%" rowspan="3" class='title'>거<br>
            래<br>
            대<br>
			금</td>
          	<td class='title'>공급가</td>
          	<td>&nbsp;
              <input type="text" name="buy_s_amt" value="<%=Util.parseDecimal(cd_bean.getBuy_s_amt())%>" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_buy_v_amt();' readonly>
              원
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			
			</td>
          </tr>		  
          <tr>
          	<td class='title'>부가세</td>
          	<td>&nbsp;
              <input type="text" name="buy_v_amt" value="<%=Util.parseDecimal(cd_bean.getBuy_v_amt())%>" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_buy_amt();' readonly>
              원
			  </td>
          </tr>
          <tr>
           	<td class='title'>합계</td>
          	<td>&nbsp;
              <input type="text" name="buy_amt" value="<%=Util.parseDecimal(cd_bean.getBuy_amt())%>" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value);  tot_buy_amt();' readonly>
              원
              
            </td>
          </tr>
          
          <tr>
          	<td colspan="2" class='title'>거래처</td>
          	<td>&nbsp;
              <input name="ven_name" type="text" class="whitetext" value="<%=cd_bean.getVen_name()%>" size="50" style='IME-MODE: active' onKeyDown="javasript:search_enter(1)" readonly>
			  <input type="hidden" name="ven_code" value="<%=cd_bean.getVen_code()%>">
			  &nbsp;&nbsp;&nbsp;&nbsp;
			  (사업자번호:<input type="text" class="whitetext" size="12" name="ven_nm_cd"  value="<%=AddUtil.ChangeEnt_no(String.valueOf(vendor.get("S_IDNO")))%>">)
			</td>
       	  </tr>
   		  <tr>
          	<td colspan="2" class='title'>과세유형</td>
          	<td >&nbsp;<input type="radio" name="ven_st" value="1" <%if(cd_bean.getVen_st().equals("1"))%>checked<%%>  onClick="javascript:cng_vs_input()">일반과세
			     &nbsp;<input type="radio" name="ven_st" value="2" <%if(cd_bean.getVen_st().equals("2"))%>checked<%%>  onClick="javascript:cng_vs_input()">간이과세
			     &nbsp;<input type="radio" name="ven_st" value="3" <%if(cd_bean.getVen_st().equals("3"))%>checked<%%>  onClick="javascript:cng_vs_input()">면세
			     &nbsp;<input type="radio" name="ven_st" value="4" <%if(cd_bean.getVen_st().equals("4"))%>checked<%%>  onClick="javascript:cng_vs_input()">비영리법인(국가기관/단체)
				 </td>
       	  </tr>		            		  
          <tr>
            <td colspan="2" class='title'>사용자</td>
          	<td width="85%">&nbsp;
		  	  <input name="user_nm" type="text" class="whitetext" value="<%=c_db.getNameById(cd_bean.getBuy_user_id(), "USER")%>" size="30" style='IME-MODE: active' >
			  <input type="hidden" name="buy_user_id" value="<%=cd_bean.getBuy_user_id()%>">
			  </td>
          </tr>
		  <%if(!cd_bean.getSiokno().equals("")){%>
		  <tr>
            <td colspan="2" class='title'>현금영수증 승인번호</td>
          	<td width="85%">&nbsp;
		  	  <input name="user_nm" type="text" class="text" value="<%=cd_bean.getSiokno()%>" size="30" style='IME-MODE: active'>
			  </td>
          </tr>
		  <%}%>
          <tr>
          	<td colspan="2" class='title'>계정과목</td>
          	<td>
			  <table width="100%" border="0">
			    <tr>
			      <td width="90"><input type="radio" name="acct_code" value="00004" onClick="javascript:cng_input()" <%if(cd_bean.getAcct_code().equals("00004"))%>checked<%%>>
				  차량유류대</td>
			    </tr>
			    
			  </table>
		    </td>
          </tr>
        </table>
	  </td>
    </tr>
    <tR>
        <td class=h></td>
    </tr>
    <tR>
        <td class=h></td>
    </tr>
    
    <tr id=tr_acct2 style='display:<%if(cd_bean.getAcct_code().equals("00004")){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line">
      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="15%" class='title'>구분</td>          
          <td>&nbsp;
            <input type="radio" name="acct_code_g" value="13" <%if(cd_bean.getAcct_code_g().equals("13"))%>checked<%%>>가솔린
			<input type="radio" name="acct_code_g" value="4"<%if(cd_bean.getAcct_code_g().equals("4"))%>checked<%%>>디젤
			<input type="radio" name="acct_code_g" value="5" <%if(cd_bean.getAcct_code_g().equals("5"))%>checked<%%>>LPG
			<%-- <input type="radio" name="acct_code_g" value="27" <%if(cd_bean.getAcct_code_g().equals("27"))%>checked<%%>>전기차충전 --%>	<!-- 전기차충전 추가 -->			
			<input type="radio" name="acct_code_g" value="27" <%if(cd_bean.getAcct_code_g().equals("27"))%>checked<%%>>전기/수소	<!-- 전기/수소 추가 2021.01.28. -->			
		 </td>
        </tr>
		<tr>
					<td width="15%" class='title'>용도</td>
					<td width="85%">&nbsp;
						<input type="radio" name="acct_code_g2" value="12" <%if(cd_bean.getAcct_code_g2().equals("12"))%>checked<%%>>탁송
					</td>
				</tr>
      </table></td>
    </tr>

    <tr id=tr_acct3_1 style='display:<%if(cd_bean.getAcct_code().equals("00004") || cd_bean.getAcct_code().equals("00006") || cd_bean.getAcct_code().equals("00018") || cd_bean.getAcct_code().equals("00019") || ( cd_bean.getAcct_code().equals("00005") && (!cd_bean.getAcct_code_g().equals("18") && !cd_bean.getAcct_code_g().equals("22") ) )  ){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="15%" class='title'>차량</td>
          <td width="85%">&nbsp;
            <input name="item_name" type="text" class="text" value="<%=cd_bean.getItem_name()%>" size="50" style='IME-MODE: active' onKeyDown="javasript:Rent_enter('0')" readonly>
			<input type="hidden" name="rent_l_cd" value="<%=cd_bean.getRent_l_cd()%>">
			<input type="hidden" name="serv_id" value="<%=cd_bean.getServ_id()%>">
			<input type="hidden" name="item_code" value="<%=cd_bean.getItem_code()%>">
		   <!--<a href="javascript:Rent_search('0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			&nbsp;(차량번호/상호로 검색)
			--></td>       
      </table></td>
    </tr>
    
    <tr id=tr_acct3_2 style='display:<%if(cd_bean.getAcct_code().equals("00004")){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
            <td width="15%" class='title'>주유량</td>
		    <td width="25%">&nbsp;
		          	<input type='text' size='7' class='num'  value="<%=cd_bean.getOil_liter()%>" name='oil_liter' onBlur='javascript:set_oil_price();'>&nbsp;L	
            &nbsp;* 필수
			</td>
			<td width="15%" class='title'>주유단가</td>
			<td width="15%">&nbsp;<input type='text' size='7' class='num'  value="<%%>" name='oil_price' >&nbsp;원
			<td width="15%" class='title'>주행거리</td>
		    <td width="15%">&nbsp;
		    	<input type='text' size='7' class='num'  value="<%=cd_bean.getTot_dist()%>" name='tot_dist' >&nbsp;km
		    </td>
			
		  
          </td>
        </tr>	
       </table></td>
    </tr>
    
        
    <tr id=tr_acct98 style='display:""'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="15%" class='title'>적요</td>
          <td width="85%">&nbsp;
		    <textarea name="acct_cont" cols="90" rows="2" class="text"><%=cd_bean.getAcct_cont()%></textarea>
            </td>
        </tr>
      </table></td>
    </tr>
    
    <tr>
    	<td class=h></td>
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
 	 String ht_acct_cont = ""; 	 
 	 
      for(int j=1; j< 19; j++){
      
        if ( j < vt_i_size1 ) {
        	Hashtable ht_item = (Hashtable)vt_item.elementAt(j);
        	ht_item_name = String.valueOf(ht_item.get("ITEM_NAME"));
        	ht_rent_l_cd = String.valueOf(ht_item.get("RENT_L_CD"));
        	ht_item_code = String.valueOf(ht_item.get("ITEM_CODE"));
        	ht_serv_id = String.valueOf(ht_item.get("SERV_ID"));
        	ht_call_t_nm = String.valueOf(ht_item.get("CALL_T_NM"));
        	ht_call_t_tel = String.valueOf(ht_item.get("CALL_T_TEL"));        
        	ht_acct_cont = String.valueOf(ht_item.get("ACCT_CONT"));
        	        			        					
        } else {	
        	ht_item_name = "";
        	ht_rent_l_cd = "";
        	ht_item_code = "";
        	ht_serv_id = "";
        	ht_call_t_nm = "";
     		ht_call_t_tel = "";     	
     		ht_acct_cont = ""; 	  		
        }
        
  	%>
     <tr id=tr_acct3_<%=j%>_1  style='display:<%if( j < vt_i_size1 ){%>""<%}else{%>none<%}%>'>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="15%" class='title'>차량</td>
          <td width="85%">&nbsp;
            <input name="item_name" type="text" class="text" value="<%=ht_item_name%>" size="50" style='IME-MODE: active' onKeyDown="javasript:Rent_enter('<%=j%>')">
				<input type="hidden" name="rent_l_cd" value="<%=ht_rent_l_cd%>">
				<input type="hidden" name="serv_id" value="<%=ht_serv_id%>">
				<input type="hidden" name="item_code" value="<%=ht_item_code%>">
            <a href="javascript:Rent_search('<%=j%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
              &nbsp;(차량번호/상호로 검색)</td>
        </tr>
     		
      </table></td>
    </tr>     
   
    <tr id=tr_acct3_<%=j%>_98 style='display:<%if( j < vt_i_size1 ){%>""<%}else{%>none<%}%>'>
    	<td colspan="2" >
    		<table border="0" cellspacing="0" cellpadding="0" width='100%'>
        		<tr>
        			<td class="line">
	        			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        			<tr>
			          			<td width="15%" class='title'>적요</td>
			          			<td width="85%">&nbsp;
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
      <td colspan="2" class=h></td>
    </tr>	
    <tr><td class=line2 colspan=2></td></tr>
    <tr>
      <td colspan="2" class="line">
      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="15%" class='title'>전표적요</td>
          <td width="85%">&nbsp;
		    <textarea name="doc_acct_cont" cols="100" rows="2" class="text"><%=doc_acct_cont%></textarea>
            </td>
        </tr>
      </table></td>
    </tr>	
    <tR>
        <td class=h></td>
    </tr><tR>
        <td class=h></td>
    </tr>
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
