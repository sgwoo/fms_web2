<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	if(gubun1.equals("") && gubun3.equals("") && st_dt.equals("") && end_dt.equals("")){
		gubun1 = "1";
		gubun3 = "1";
	}

	if(gubun1.equals("3")){
		gubun2 = "";
		gubun3 = "1";
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
	
	vt = CardDb.getCardRtnStat(card_kind, s_yy, s_mm, gubun1, gubun2, st_dt, end_dt);
	vt_size = vt.size();	
	
	
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
		if(fm.s_yy.value == '2021' && toInt(fm.s_mm.value) > 0 && toInt(fm.s_mm.value) < 7){
			alert('2021년7월 이전 데이타는 없습니다.'); return;
		}
		fm.action = "card_rtn_sc.jsp";
		if(fm.gubun3.value == '2'){
			fm.action = "card_rtn_sc2.jsp";
		}
		fm.target = "_self";
		fm.submit();
  }
  
	function card_Search(){
		var fm = document.form1;
		if(fm.s_yy.value == '2021' && toInt(fm.s_mm.value) > 0 && toInt(fm.s_mm.value) < 7){
			alert('2021년7월 이전 데이타는 없습니다.'); return;
		}
		fm.action="card_rtn_sc.jsp";
		if(fm.gubun3.value == '2'){
			fm.action = "card_rtn_sc2.jsp";
		}
		fm.target="_self";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') card_Search();
	}	
	
	  function CardStatBase(rtn_dt, cardno){
			var fm = document.form1;
			fm.rtn_dt.value = rtn_dt;
			fm.cardno.value = cardno;
			fm.action = "card_rtn_list.jsp";
			window.open("about:blank", "CardRtnList", "left=350, top=50, width=1000, height=800, scrollbars=yes, status=yes");
			fm.target = "CardRtnList";
			fm.submit();
	  }	
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='cash_rtn_sc.jsp' method='post' target='t_content'>
<input type='hidden' name='rtn_dt' value=''>
<input type='hidden' name='cardno' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1050>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>카드대금상환스케줄</span></td>
	  </tr>
	   
	  <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td>&nbsp;
                        구분 : 
              <select name="gubun3" id="gubun3">
                <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>카드사별</option>
                <option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>일자별</option>
              </select>
              &nbsp;
               카드사 : 
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
                        용도구분 : 
              <select name="gubun2" id="gubun2" onChange="javascript:cng_card_kind(this.value)">
                <option value=''>선택</option>
                <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>구매자금</option>
                <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>업무용등</option>
                <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>국세/지방세</option>
              </select>
            			      &nbsp;&nbsp;&nbsp;
            			<input type='radio' name="gubun1" value='1' <%if(gubun1.equals("1")){%>checked<%}%>>월별
            			&nbsp;      
						<select name="s_yy">
			  			<%for(int i=2021; i<=AddUtil.getDate2(1)+1; i++){%>
							<option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>년</option>
						<%}%>
						</select>
	        			<select name="s_mm">
	        			<option value="" <%if(s_mm.equals("")){%>selected<%}%>>전체</option>
	          			<%for(int i=1; i<=12; i++){%>
	          				<option value="<%=AddUtil.addZero2(i)%>" <%if(s_mm.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>월</option>
	          			<%}%>
	        			</select>                
            			&nbsp;&nbsp;&nbsp;      
            			<input type='radio' name="gubun1" value='2' <%if(gubun1.equals("2")){%>checked<%}%>>기간
            			&nbsp;  
            			<input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">    
                        
                        
              &nbsp;<a href="javascript:card_Search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
            </td>
          </tr>
        </table>
      </td>
    </tr>
     
    <tr> 
        <td align="right">(금액단위:원, 전일마감현재)</td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>	
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='3%' rowspan='2' class='title'>연번</td>
                    <td width='10%' rowspan='2' class='title'>카드사</td>
                    <td rowspan='2' class='title'>카드번호</td>
                    <td width='10%' rowspan='2' class='title'>용도</td>
                    <td colspan='5' class='title'>사용/상환현황</td>
                    <td width='10%' rowspan='2' class='title'>캐쉬백</td>                    
                </tr>
                <tr>
                    <td width='10%' class='title'>상환구분</td>
                    <td width='10%' class='title'>당초예정일자</td>
                    <td width='10%' class='title'>사용한도</td>
                    <td width='10%' class='title'>상환예정</td>
                    <td width='10%' class='title'>한도잔액</td>
                </tr>                
                <%
                	if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
						            total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CONT_AMT")));
					      			total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("BASE_AMT")));
					      			total_amt3 = total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("JAN_AMT")));
					      			total_amt4 = total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("SAVE_AMT")));
					      			
					      			count++;
					      %>
                <tr>
                    <td class='title'><%=count%></td>
                    <td align="center"><%=ht.get("NM")%></td>
                    <td align="center">
                    	<%if(String.valueOf(ht.get("CARDNO")).equals("임/직원업무용")){%>
                    		<%=ht.get("CARDNO")%>
                    	<%}else{%>
                    		<a href="javascript:CardStatBase('<%=ht.get("RTN_DT")%>', '<%=ht.get("CARDNO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CARDNO")%></a>
                    	<%}%>
                    </td>
                    <td align="center"><%=ht.get("CARD_ST_NM")%></td>
                    <td align="center">
                    	<%if(String.valueOf(ht.get("RTN_DT")).equals(String.valueOf(ht.get("O_RTN_DT")))){%>
                    		정기
                    	<%}else{%>
                    		<font color='red'>조기</font>
                    	<%}%>
                    </td>
                    <td align="center">
                        <%if(String.valueOf(ht.get("RTN_DT")).equals(String.valueOf(ht.get("O_RTN_DT")))){%>
                    		<%=AddUtil.ChangeDate2(String.valueOf(ht.get("O_RTN_DT")))%>
                    	<%}else{%>
                    		<font color='red'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("O_RTN_DT")))%></font>
                    	<%}%>
                    </td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CONT_AMT")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("BASE_AMT")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("JAN_AMT")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("SAVE_AMT")))%></td>           
                    <!-- <td class='title'> <%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>      -->                                           
                </tr>
                <%		
                		}%>
                <tr>
                    <td class='title' colspan='6'>합계</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt2)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt3)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt4)%></td>
                    <!-- <td class='title'> </td> -->
                </tr>		            
		        <%}else{%>
                <tr>
                    <td colspan="11" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		        <%}%>
            </table>
	    </td>
    </tr>   
  </table>
</form>
</body>
</html>
