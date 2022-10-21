<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.tint.*, acar.car_office.*, acar.bill_mng.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "08", "11");	
	
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String tot_amt = request.getParameter("tot_amt")==null?"":request.getParameter("tot_amt");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	Hashtable car = new Hashtable();
	
	if(!car_mng_id.equals(""))	car = t_db.getUseLcCont(car_mng_id, "");
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
	//카드정보
	Hashtable ht2 = new Hashtable();
	ht2 = CardDb.getCardUserInfo(user_id);
	
	String ven_code = "";
	String ven_name = "";
	
	
	if(!ven_code.equals("")){
		Hashtable vendor = neoe_db.getVendorCase(ven_code);//-> neoe_db 변환
		ven_name = String.valueOf(vendor.get("VEN_NAME"));
	}
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	

	//용품업체 조회
	function search_off()
	{
		var fm = document.form1;	
		window.open("/acar/cus0601/cus0603_frame.jsp?from_page=/fms2/tint/tint_reg_card.jsp&t_wd="+fm.off_nm.value, "SERV_OFF", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//용품업체 보기
	function view_off()
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("선택된 용품업체가 없습니다."); return;}
		window.open("/acar/cus0601/cus0603_d_frame.jsp?from_page=/fms2/consignment/cons_i_c.jsp&off_id="+fm.off_id.value, "SERV_OFF", "left=10, top=10, width=900, height=260, scrollbars=yes, status=yes, resizable=yes");
	}		
		
	//자동차 조회
	function search_car()
	{
		var fm = document.form1;
		window.open("/tax/pop_search/s_car.jsp?go_url=/fms2/tint/tint_reg_card.jsp&s_kd=2&t_wd="+fm.car_no.value, "CAR", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//자동차 보기
	function view_car()
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("선택된 용품업체가 없습니다."); return;}
		if(fm.car_mng_id.value == ""){ alert("선택된 자동차가 없습니다."); return;}	
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&car_mng_id="+fm.car_mng_id.value+"&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}			

	//용품구분에 따른 셋팅
	function cng_input(){
		var fm = document.form1;
		
		if(fm.tint_st.checked == true){
			tr_tint_1.style.display	= '';
			tr_tint_2.style.display	= '';
			tr_tint_3.style.display	= 'none';			
		}

	}	
	
	function Save(){
		var fm = document.form1;
		
		if(fm.off_id.value == "")			{ 	alert("선택된 용품업체가 없습니다."); 	return;	}
		if(fm.req_id.value == "")			{ 	alert("의뢰자를 입력하십시오."); 		return;	}	
	
		if(fm.tint_st.checked == true){
			if(fm.car_no.value == "") 		{ 	alert("선택된 차량이 없습니다. 차량번호가 없으면 차대번호를 직접 입력하세요");	return;	}
			if(fm.rent_l_cd.value == "") 	{ 	alert("차량조회가 되지 않았습니다.");	return;	}
			if(fm.film_st[0].checked == false && fm.film_st[1].checked == false && fm.film_st[2].checked == false && fm.film_st[3].checked == false)
											{ 	alert("필름구분을 선택하십시오.");		return;	}
		}
		
		if(fm.cleaner_st[0].checked == false && fm.cleaner_st[1].checked == false)
											{ 	alert("청소용품 구분을 선택하십시오.");	return;	}
		if(fm.sup_est_dt.value == ''){	alert('작업마감요청일시를 입력하여 주십시오.');		fm.sup_est_dt.focus(); 		return;		}
		
		if(fm.card_file.value == ''){	alert('카드전표를 JPG 스캔한 후 등록하십시오.'); 	fm.card_file.focus(); 	return; }
			
				//스캔파일 확장자가 ".JPG" 인치 체크 
				
				var file = fm.card_file.value;
				file = file.slice(file.indexOf("\\") +1 );
				ext = file.slice(file.indexOf(".")).toLowerCase();
				
				if(ext != '.jpg'){
					alert('JPG가 아닙니다. JPG로 스캔한 파일만 등록이 가능합니다.'); 	
					fm.card_file.focus(); 	
					return;
				}
		
		if(confirm('등록하시겠습니까?')){		
			document.domain = "amazoncar.co.kr";
			fm.action='https://fms3.amazoncar.co.kr/card/doc_reg/tint_reg_card_a.jsp';	
			fm.target='i_no';
			fm.submit();
		}		
	}
	
	function enter(nm) {
		var keyValue = event.keyCode;
		if (keyValue =='13') {
			if(nm == 'car_no')	search_car();
		}
	}	

	//네오엠조회-신용카드
	function Neom_search(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == 'cardno')	fm.t_wd.value = fm.cardno_search.value;
		window.open("about:blank",'Neom_search','scrollbars=yes,status=no,resizable=yes,width=600,height=500,left=350,top=150');		
		fm.action = "neom_search.jsp?t_wd="+fm.t_wd.value;
		fm.target = "Neom_search";
		fm.submit();		
	}
	
	function Neom_enter(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Neom_search(s_kd);
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
	function tot_buy_amt(){
		var fm = document.form1;		
		
		fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
		fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));		
		
	}
	//직원조회
	function User_search(nm, idx)
	{
		var fm = document.form1;
		var t_wd = fm.user_nm.value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');		
		fm.action = "user_search.jsp?nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();		
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
<form action="" name="form1" method="POST" enctype="multipart/form-data">

 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
 <input type="hidden" name="s_kd" value="">
<input type="hidden" name="t_wd" value=""> 
<input type="hidden" name="etc" value=""> 
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>협력업체 > 용품관리 ><span class=style5>용품의뢰 카드결재 등록</span></span></td>
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
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr> 
            		<td width='13%'  class='title'>카드 조회</td>
            		<td colspan="3">&nbsp; 
            			<input name="cardno_search" type="text" class="text" value="" size="30" style='IME-MODE: active' onKeyDown="javasript:Neom_enter('cardno')" >
              			&nbsp;<a href="javascript:Neom_search('cardno');" ><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
						&nbsp;<span style="font-size:8pt">(카드번호/사용자명으로 검색)</span>
            		</td>
          		</tr>
          
          		<tr> 
            		<td width='13%'  class='title'>신용카드번호</td>
            		<td width="50%" >&nbsp; <input name="cardno" type="text" class="whitetext"  value="<%=ht2.get("CARDNO")==null?"":ht2.get("CARDNO")%>" size="30"  ></td>
            		<td width="13%" class='title'>사용자구분</td>
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
			        	<input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(user_id, "USER")%>" size="12" style='IME-MODE: active' onKeyDown="javasript:enter('buy_user_id', '0')"> 
			            <input type="hidden" name="buy_user_id" value="<%=user_id%>">
			            <a href="javascript:User_search('buy_user_id', '0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
		            </td>
          		</tr>
          		
        	</table>
        </td>
    </tr>   
    <tr>
    	<td class=h></td>
    </tr>
	<tr>
    	<td colspan="2" class=line>
	    	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
          		<tr>
            		<td  width="13%" colspan="2" class='title'>거래일자</td>
          			<td colspan="3">&nbsp;
		  	  			<input name="buy_dt" type="text" class="text" value="" size="12" onBlur='javascript:this.value=ChangeDate2(this.value)'>
		  	  		</td>
          		</tr>
          		<tr>
          			<td  width="13%" colspan="2" class='title'>거래처</td>
          			<td width=50% >&nbsp;
		            	<input name="ven_name" type="text" class="text" value="<%=ven_name%>" size="35" style='IME-MODE: active' onKeyDown="javasript:search_enter(1)">
						<input type="hidden" name="ven_code" value="<%=ven_code%>">
						<input type="hidden"  name="off_id"  value="">
						<input type="hidden" name="ve_st" value="">
						<a href="javascript:search(1);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a> 
						<span style="font-size:8pt">(카드 가맹점, <b>사업자등록번호</b>로 검색)</span>
					</td>
					<td width=10% class='title' style="font-size:8pt">사업자등록번호</td>
					<td>&nbsp;
		            	<input type="text" class="whitetext"   name="ven_nm_cd"  value="">&nbsp;						
					</td>
       	  		</tr>
          		<tr>
          			<td width="3%" rowspan="3" class='title'>거<br>래<br>금<br>액</td>
          			<td class='title' width="10%"  >공급가</td>
          			<td colspan="3" >&nbsp;
              			<input type="text" name="buy_s_amt" value="" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_buy_v_amt();'>원
						
            		</td>
          		</tr>
          
          		<tr>
          			<td class='title'>부가세</td>
          			<td colspan="3" >&nbsp;
              			<input type="text" name="buy_v_amt" value="" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_buy_amt();'>원
						
            		</td>
            	</tr>          
          		<tr>
          			<td width="7%" class='title'>합계</td>
          			<td  colspan="3" >&nbsp;
              			<input type="text" name="buy_amt" value="" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); tot_buy_amt();'>원
              			&nbsp;&nbsp;<font color="blue">※ 부가세 끝전조정 <input type="radio" name="vat_Rdio" value="0" onClick="javascript:cng_input_vat()" > 상향
			      		<input type="radio" name="vat_Rdio" value="1" onClick="javascript:cng_input_vat()">하향 &nbsp;</font>
              		</td>
          		</tr>
	        </table>
	  	</td>
    </tr> 
    
    <tr>
        <td class=h></td>
    </tr>
	<tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width="13%" class='title'>영수증스캔파일</td>
					<td colspan="3">&nbsp;
					<input type="file" name="card_file" size = "50"></td>
				</tr>
			</table>
        </td>
    </tr>
	<tr>
        <td class=h></td>
    </tr> 
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				
                <tr> 
					<td width='13%' class='title'>계정과목</td>
          			<td width="20%"><input type="radio" name="acct_code" value="00005" onClick="javascript:cng_input()" checked>차량정비비
									<input type="hidden" name="acct_code_g" value="6">
					</td>
                    <td width='13%' class='title'>의뢰구분</td>
                    <td width="20%">&nbsp;
        			  <input type='radio' name="tint_st" value='1' checked>
        				차량별용품의뢰
        			</td>		  
					<td width='13%' class='title'>의뢰자</td>
                    <td width="20%">&nbsp;
                      <select name='req_id'>
                        <option value="">선택</option>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}%>
                      </select></td>			
                </tr>
			
            </table>
        </td>
    </tr>
	<tr>
	    <td></td>
	</tr>
	<tr>
	    <td style='background-color:e5e5e5; height:1'></td>
	</tr>
	<tr>
	    <td></td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>용품요청내역</span></td>
	</tr>
    <tr id=tr_tint_1 style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr><td class=line2 style='height:1'></td></tr>
                <tr> 
                    <td width='13%' class='title'>차량번호/차대번호</td>
                    <td width='37%'>&nbsp;
        			  <input type='text' name="car_no" value='' size='30' class='text' onKeyDown="javasript:enter('car_no')">
        			  <input type='hidden' name='car_mng_id' value=''>
        			  <input type='hidden' name='rent_mng_id' value=''>
        			  <input type='hidden' name='rent_l_cd' value=''>
        			  <input type='hidden' name='client_id' value=''>
        			  <span class="b"><a href="javascript:search_car()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>
        			<td width='13%' class='title'>차명</td>
        			<td width='37%'>&nbsp;
    			    <input type='text' name="car_nm" value='' size='40' class='whitetext' readonly></td>
                </tr>
    		    <tr>
        		    <td class='title'>연식</td>
        			<td>&nbsp;
        			  <input type='text' name="car_y_form" value='' size='40' class='whitetext' readonly>
        			</td>
        		    <td class='title'>색상</td>
        			<td>&nbsp;
    			    <input type='text' name="color" value='' size='40' class='whitetext' readonly></td>			
    		    </tr>
    		    <tr>
        		    <td class='title'>고객명</td>
        			<td colspan="3">&nbsp;
        			  <input type='text' name="firm_nm" value='' size='70' class='whitetext' readonly>
        			</td>
    		    </tr>
		    </table>
	    </td>
    </tr>
	<tr id=tr_tint_2 style="display:''">
	    <td>&nbsp;</td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td colspan="2" class=title>썬팅</td>
                    <td colspan="2" class=title>청소용품</td>
                </tr>
                <tr>
                    <td width="13%" class=title>필름선택</td>
                    <td width="37%" >&nbsp;
        			  <input type='radio' name="film_st" value=''>
        				없음
        			  <input type='radio' name="film_st" value='1'>
        				일반
        			  <input type='radio' name="film_st" value='2'>
        				3M
        			  <input type='radio' name="film_st" value='3'>
        				루마
        			</td>
                    <td width="13%" class=title>기본</td>
                    <td width="37%">&nbsp;
        			  <input type='radio' name="cleaner_st" value='1'>
        				있음
        			  <input type='radio' name="cleaner_st" value='2'>
        				없음
                    </td>
                </tr>
                <tr>
                    <td class=title>가시광선투과율</td>
                    <td>&nbsp;
        			  <input type='text' name='sun_per' size='3' value='' class='default' >%
        			</td>
                    <td class=title>추가</td>
                    <td>&nbsp;
                        <input type='text' name='cleaner_add' size='40' value='' class='default' >
                    </td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>네비게이션</td>
                    <td colspan="2" class=title>기타</td>
                </tr>
                <tr>
                    <td width="10%" class=title>상품명</td>
                    <td>&nbsp;
                        <input type='text' name='navi_nm' size='45' value='' class='default' >
                    </td>
                    <td colspan="2" rowspan="2">&nbsp;
    			    <textarea name="sup_other" cols="55" rows="4" class="default"></textarea></td>
                </tr>
                <tr>
                    <td class=title>(예상)가격</td>
                    <td>&nbsp;
                        <input type='text' name='navi_est_amt' maxlength='10' value='' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원 </td>
                </tr>
                <tr>
                    <td class=title>블랙박스</td>
                    <td colspan="3">&nbsp;
        			  <input type='radio' name="blackbox_yn" value='N'>
				    미장착
				    <input type='radio' name="blackbox_yn" value='Y'>
				    장착
        			</td>
                </tr>
                <tr>
                    <td class=title>적요</td>
                    <td colspan="3">&nbsp;
        			  <textarea name="sup_etc" cols="105" rows="4" class="default"></textarea>
        			</td>
                </tr>
                <tr>
                    <td class=title style='height:36'>작업마감<br>요청일시</td>
                    <td colspan="3">&nbsp;
        			  <input type='text' size='11' name='sup_est_dt' maxlength='10' class='default' value='' onBlur='javscript:this.value = ChangeDate(this.value);'>
        			  <input type='text' size='2' name='sup_est_h' class='default' value=''>시
        			</td>
                </tr>
				
    		</table>
	    </td>
	</tr> 		
	<tr id=tr_tint_3 style='display:none'>
	    <td><font color=#666666>&nbsp;※ 청소함대량구입일때는 <b>적요</b>란에 <b>구입수량</b>을 적어주십시오. (예: 청소함 40개)</font></td>
	</tr>
	<tr>
    	<td class=h></td>
    </tr>	
	
    <tr>
    	<td class=h></td>
    </tr>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>	
	<%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>			
	<tr>
	    <td align="center">&nbsp;<a href="javascript:Save()"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></td>
	</tr>
	<% } %>		
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>				
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;	
//-->
</script>
</body>
</html>