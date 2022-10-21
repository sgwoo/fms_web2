<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	if(gubun1.equals("") && st_dt.equals("") && end_dt.equals("")){
		gubun1 = "1";
	}

	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");

	
	//카드종류 리스트 조회
	Vector card_kinds = CardDb.getCardKinds("CARD_SCD", "");
	int ck_size = card_kinds.size();	
	
	String card_kind = request.getParameter("card_kind")==null?"":request.getParameter("card_kind");
	
	//카드스케줄 리스트 조회
	Vector vt = new Vector();
	int vt_size = 0;	
	
	if(gubun1.equals("1") && card_kind.equals("")){
		
	}else{	
		vt = CardDb.getCardPayStat(card_kind, s_yy, s_mm, gubun1, gubun2, st_dt, end_dt, gubun3);
		vt_size = vt.size();	
	}
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;	
	long total_amt5 = 0;	
	
	int count = 0;

	
%>



<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
  function cng_card_kind(value){
		var fm = document.form1;
		if(fm.s_yy.value == '2018' && toInt(fm.s_mm.value) < 7){
			alert('2018년7월 이전 데이타는 없습니다.'); return;
		}
		fm.action = "card_pay_sc.jsp";
		if(fm.card_kind.value == ''){
			fm.action = "card_pay_sc2.jsp";
		}
		fm.target = "_self";
		fm.submit();
  }
  
	function card_Search(){
		var fm = document.form1;
		if(fm.s_yy.value == '2018' && toInt(fm.s_mm.value) < 7){
			alert('2018년7월 이전 데이타는 없습니다.'); return;
		}
		fm.action="card_pay_sc.jsp";
		if(fm.card_kind.value == ''){
			fm.action = "card_pay_sc2.jsp";
		}
		fm.target="_self";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') card_Search();
	}	 
	
	function send_kakao_alimtalk(){
		var SUBWIN="/acar/kakao/alim_talk.jsp?user_id=<%=ck_acar_id%>";
		window.open(SUBWIN, "MemoUp", "left=10, top=10, width=850, height=850, scrollbars=yes");
	}	
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='cash_back_sc.jsp' method='post' target='t_content'>
<input type='hidden' name='mode' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1480>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>카드사별수금현황</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='20%'  class='title'>거래처명</td>
            <td>&nbsp;
              <select name="card_kind" id="card_kind" onChange="javascript:cng_card_kind(this.value)" >
                <option value=''>선택</option>
                <%if(ck_size > 0){
                    for (int i = 0 ; i < ck_size ; i++){
                      Hashtable ht = (Hashtable)card_kinds.elementAt(i);
                %>
                <option value='<%= ht.get("CODE") %>' <%if(card_kind.equals(String.valueOf(ht.get("CODE")))){%>selected<%}%>><%= ht.get("CARD_KIND") %></option>
                <%	}
                  }
                %>
              </select>
              &nbsp;
                        구분 : 
              <select name="gubun2" id="gubun2" onChange="javascript:cng_card_kind(this.value)">
                <option value=''>선택</option>
                <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>구매자금</option>
                <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>업무용등</option>
                <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>국세/지방세</option>
              </select>
              			&nbsp;&nbsp;&nbsp;
						<select name="gubun3" id="gubun3" onChange="">
							<option value=''>선택</option>
						        <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>처리일자</option>
						        <option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>입금일</option>
						</select>
						              			
            			      &nbsp;&nbsp;&nbsp;
            			<input type='radio' name="gubun1" value='1' <%if(gubun1.equals("")||gubun1.equals("1")){%>checked<%}%>>월별
            			&nbsp;&nbsp;&nbsp;      
						<select name="s_yy">
			  			<%for(int i=2018; i<=AddUtil.getDate2(1)+1; i++){%>
							<option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>년</option>
						<%}%>
						</select>
	        			<select name="s_mm">
	          			<%for(int i=1; i<=12; i++){%>
	          				<option value="<%=AddUtil.addZero2(i)%>" <%if(s_mm.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>월</option>
	          			<%}%>
	        			</select>                
            			&nbsp;&nbsp;&nbsp;      
            			<input type='radio' name="gubun1" value='2' <%if(gubun1.equals("2")){%>checked<%}%>>기간
            			&nbsp;&nbsp;&nbsp;  
            			<input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">    

                        
              &nbsp;<a href="javascript:card_Search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <%if(gubun1.equals("1") && card_kind.equals("")){%>
    <%}else{%>
    <tr> 
        <td align="right">(금액단위:원)</td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>	
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' rowspan='2' class='title'>연번</td>
                    <td width='7%' rowspan='2' class='title'>처리일자</td>
                    <td colspan='2' class='title'>사용현황</td>
                    <td colspan='3' class='title'>Cash back</td>
                    <td colspan='3' class='title'>입금현황</td>
                    <td width='7%' rowspan='2' class='title'>미수금액</td>
                    <td width='24%' rowspan='2' class='title'>비고</td>
                </tr>
                <tr>
                    <td width='8%' class='title'>구분</td>
                    <td width='8%' class='title'>금액</td>
                    <td width='5%' class='title'>요율</td>
                    <td width='7%' class='title'>적립금</td>
                    <td width='7%' class='title'>입금예정일</td>
                    <td width='7%' class='title'>입금일</td>
                    <td width='8%' class='title'>금액</td>
                    <td width='7%' class='title'>손익금액</td>
                </tr>                
                <%
                	if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            	//구매자금
					            	if(gubun2.equals("1") && !String.valueOf(ht.get("BASE_G")).equals("자동차대금")){
					            		continue;					            		
					            	}
					            	//업무용등
					            	if(gubun2.equals("2") && (String.valueOf(ht.get("BASE_G")).equals("자동차대금")||String.valueOf(ht.get("BASE_G")).equals("가지급금")||String.valueOf(ht.get("BASE_G")).equals("대여사업차량")||String.valueOf(ht.get("BASE_G")).equals("리스사업차량")||String.valueOf(ht.get("BASE_G")).equals("세금과공과")||String.valueOf(ht.get("BASE_G")).equals("자동차세")||String.valueOf(ht.get("BASE_G")).equals("환경개선부담금"))){
					            		continue;					            		
					            	}
					            	//국세/지방세
					            	if(gubun2.equals("3") && !String.valueOf(ht.get("BASE_G")).equals("가지급금") && !String.valueOf(ht.get("BASE_G")).equals("대여사업차량") && !String.valueOf(ht.get("BASE_G")).equals("리스사업차량") && !String.valueOf(ht.get("BASE_G")).equals("세금과공과") && !String.valueOf(ht.get("BASE_G")).equals("자동차세") && !String.valueOf(ht.get("BASE_G")).equals("환경개선부담금")){
					            		continue;					            		
					            	}
				      				if(AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT"))) < 0){
				      					ht.put("DLY_AMT","0");				      				
				      				}
									
				      				long incom_amt = AddUtil.parseLong(String.valueOf(ht.get("INCOM_AMT")));
				      				long m_amt = AddUtil.parseLong(String.valueOf(ht.get("M_AMT")));
				      				if(m_amt<0){
				      					incom_amt = incom_amt+m_amt;
				      				}
						            total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("BASE_AMT")));
					      			total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("SAVE_AMT")));
					      			total_amt3 = total_amt3 + incom_amt;
					      			total_amt5 = total_amt5 + m_amt;
					      			total_amt4 = total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
					      			
					      			count++;
					      			
					      %>
                <tr>
                    <td class='title'><%=count%></td>
                    <td class='title'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BASE_DT")))%></td>
                    <td align="center"><%=ht.get("BASE_G")%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("BASE_AMT")))%></td>
                    <td align="center"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("SAVE_PER")),2)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("SAVE_AMT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INCOM_DT")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(incom_amt)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(m_amt)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("DLY_AMT")))%></td>
                    <td>&nbsp;
                    	<%if(!String.valueOf(ht.get("BIGO")).equals("과입금") && !String.valueOf(ht.get("BIGO")).equals("2회차 잔액")){%>
                    	<span title='<%=ht.get("BIGO")%>'><%=AddUtil.subData(String.valueOf(ht.get("BIGO")), 20)%></span>
                    	<%} %>
                    </td>
                </tr>
                <%		
                	}%>
                <tr>
                    <td class='title' colspan='3'>합계</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                    <td align="right">&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt2)%></td>
                    <td align="right">&nbsp;</td>
                    <td align="right">&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt3)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt5)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt4)%></td>
                    <td align="right">&nbsp;</td>
                </tr>		            
		            <%}else{%>
                <tr>
                    <td colspan="12" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>   
    <%	if(!card_kind.equals("")){%> 	  
    <%
    	
    	String card_com_nm = c_db.getNameByIdCode("0031", card_kind, "");
    	if(card_kind.equals("국민카드")) card_com_nm = "KB국민카드";
    	if(card_kind.equals("우리비씨")) card_com_nm = "우리카드";
    	
    	Hashtable agnt_ht = CardDb.getCardAgnt(card_kind, card_com_nm);
		%>	
	  <tr><td class=line2></td></tr>
    <tr>    
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' rowspan='2' class='title'>담당자</td>
                    <td width='10%' class='title'>성명</td>
                    <td width='9%'>&nbsp;<%=agnt_ht.get("EMP_NM")==null?"":agnt_ht.get("EMP_NM")%></td>
                    <td width='8%' class='title'>핸드폰</td>
                    <td width='13%'>&nbsp;<%if(!String.valueOf(agnt_ht.get("EMP_MTEL")).equals("")&&!String.valueOf(agnt_ht.get("EMP_MTEL")).equals("null")){%><a href="#" onclick="send_kakao_alimtalk()"><%=agnt_ht.get("EMP_MTEL")%></a><%}%></td>
                    <td width='8%' rowspan='2' class='title'>주소</td>
                    <td rowspan='2'>&nbsp;<%=agnt_ht.get("EMP_ADDR")==null?"":agnt_ht.get("EMP_ADDR")%></td>
                </tr>
                <tr>
                    <td class='title'>대표전화</td>
                    <td>&nbsp;<%=agnt_ht.get("EMP_TEL")==null?"":agnt_ht.get("EMP_TEL")%></td>
                    <td class='title'>메일</td>
                    <td>&nbsp;<%if(!String.valueOf(agnt_ht.get("EMP_EMAIL")).equals("")&&!String.valueOf(agnt_ht.get("EMP_EMAIL")).equals("null")){%><a href="mailto:<%=agnt_ht.get("EMP_EMAIL")%>"><%=agnt_ht.get("EMP_EMAIL")%></a><%}%></td>
                </tr>
            </table>
	    </td>
    </tr>
    <%	}%>
    <%}%>
    <tr> 
        <td class=h></td>
    </tr>      
  </table>
</form>
</body>
</html>
