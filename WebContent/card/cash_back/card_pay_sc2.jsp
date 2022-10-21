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
		vt = CardDb.getCardPayStat2(card_kind, s_yy, s_mm, gubun1, gubun2, st_dt, end_dt);
		vt_size = vt.size();		
	}else{	

	}
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;	
	long total_amt5 = 0;	
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;	
	long total_amt10 = 0;	
	long total_amt11 = 0;
	long total_amt12 = 0;

	
%>



<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function card_Search(){
		var fm = document.form1;
		if(fm.s_yy.value == '2018' && toInt(fm.s_mm.value) < 7){
			alert('2018년7월 이전 데이타는 없습니다.'); return;
		}
		fm.action="card_pay_sc2.jsp";
		fm.target="_self";
		fm.submit();
	}
	
	function CardStatBillOne(card_kind){
		var fm = document.form1;
		fm.card_kind.value = card_kind;
		fm.action="card_pay_sc.jsp";
		fm.target="_self";
		fm.submit();		
	}	
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='card_pay_sc.jsp' method='post' target='t_content'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='gubun1' value='1'>
<input type='hidden' name='card_kind' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1480>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>카드사별수금현황</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='20%'  class='title'>처리일자</td>
            <td>&nbsp;   
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
              &nbsp;<a href="javascript:card_Search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
        <td align="right">(금액단위:원)</td>
    </tr>	
    <!-- 영업소전체 -->
    <tr> 
        <td class=h></td>
    </tr>	
	<tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='4%' rowspan='3' class='title'>연번</td>
                    <td width='18%' rowspan='3' class='title'>거래처</td>
                    <td colspan='6' class='title'>수금현황</td>
                    <td colspan='6' class='title'>미수금내역</td>
                </tr>
                <tr>    
                    <td colspan='2' class='title'>계획</td>
                    <td colspan='2' class='title'>수금</td>
                    <td colspan='2' class='title'>미수금</td>
                    <td colspan='2' class='title'>미도래금액</td>
                    <td colspan='2' class='title'>연체금액</td>
                    <td colspan='2' class='title'>합계</td>
                </tr>
                <tr>                        
                    <td width='4%' class='title'>건수</td>
                    <td width='9%' class='title'>금액</td>
                    <td width='4%' class='title'>건수</td>
                    <td width='9%' class='title'>금액</td>
                    <td width='4%' class='title'>건수</td>
                    <td width='9%' class='title'>금액</td>
                    <td width='4%' class='title'>건수</td>
                    <td width='9%' class='title'>금액</td>
                    <td width='4%' class='title'>건수</td>
                    <td width='9%' class='title'>금액</td>
                    <td width='4%' class='title'>건수</td>
                    <td width='9%' class='title'>금액</td>
                </tr>
                <%
                	if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            
						            total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CNT1")));
					      			total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
					      			total_amt3 = total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("CNT2")));
					      			total_amt4 = total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
					      			total_amt5 = total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("CNT3")));
					      			total_amt6 = total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("AMT3")));	
					      			total_amt7 = total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("CNT4")));
					      			total_amt8 = total_amt8 + AddUtil.parseLong(String.valueOf(ht.get("AMT4")));
					      			total_amt9 = total_amt9 + AddUtil.parseLong(String.valueOf(ht.get("CNT5")));
					      			total_amt10 = total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("AMT5")));
					      			
					      			long amt11 = AddUtil.parseLong(String.valueOf(ht.get("CNT4")))+AddUtil.parseLong(String.valueOf(ht.get("CNT5")));
					      			long amt12 = AddUtil.parseLong(String.valueOf(ht.get("AMT4")))+AddUtil.parseLong(String.valueOf(ht.get("AMT5")));
					      			
					      			total_amt11 = total_amt11 + amt11;
					      			total_amt12 = total_amt12 + amt12;					      								      		
		        %>
                <tr>
                    <td class='title'><%=i+1%></td>
                    <td align="center"><a href="javascript:CardStatBillOne('<%=ht.get("CARD_KIND")%>')" onMouseOver="window.status=''; return true"><%=ht.get("NM")%></a></td>
                    <td align="right"><%=ht.get("CNT1")%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%></td>
                    <td align="right"><%=ht.get("CNT2")%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></td>
                    <td align="right"><%=ht.get("CNT3")%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT3")))%></td> 
                    <td align="right"><%=ht.get("CNT4")%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT4")))%></td>
                    <td align="right"><%=ht.get("CNT5")%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT5")))%></td>
                    <td align="right"><%=amt11%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt12)%></td>
                </tr>
                <%	}%>
                <tr>
                    <td class='title' colspan='2'>합계</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt2)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt3)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt4)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt5)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt6)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt7)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt8)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt9)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt10)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt11)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt12)%></td>
                </tr>		            
		            <%}else{%>
                <tr>
                    <td colspan="14" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>   
  </table>
</form>
</body>
</html>
