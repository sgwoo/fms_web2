<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, acar.out_car.*"%>
<jsp:useBean id="oc_db" scope="page" class="acar.out_car.OutCarDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");

	if(gubun1.equals("")){
		gubun1 = "1";
	}
	
	//카드사 리스트
	Vector vt2 = oc_db.getCarCashBackDayCd("");
	int vt_size2 = vt2.size();	
	
	String car_off_id = request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	
	//카드스케줄 리스트 조회
	Vector vt = new Vector();
	int vt_size = 0;	
	
	String mode = "";
		
	//거래처별현황
	//if(gubun1.equals("1") && !car_off_id.equals("")){
	//	mode = "one_stat";
	//	vt = oc_db.getCarCashBackBillStat(car_off_id, s_yy, s_mm);
	//	vt_size = vt.size();
	//}	
	//연체현황
	//if(gubun1.equals("3")){	
	//	mode = "dly_stat";
	//	vt = oc_db.getCarCashBackDlyStat();
	//	vt_size = vt.size();	
	//}
	//통합현황
	//if(mode.equals("")){
		mode = "all_stat";
		vt = oc_db.getCarCashBackBillStat(car_off_id, s_yy, s_mm, gubun1, st_dt, end_dt);
		vt_size = vt.size();
	//}
	
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
	function car_Search(){
		var fm = document.form1;
		fm.action="car_cash_back_bill_all_sc.jsp";
		fm.target="_self";
		fm.submit();
	}
	
	function CarStatBillList(st, car_off_id){
		var fm = document.form1;
		fm.st.value = st;
		fm.s_car_off_id.value = car_off_id;
		fm.action = "car_cash_back_bill_list.jsp";
		window.open("about:blank", "CarBaseList", "left=350, top=50, width=1100, height=800, scrollbars=yes, status=yes");
		fm.target = "CarBaseList";
		fm.submit();
	}	
	
	function CarStatBillOne(car_off_id){
		var fm = document.form1;
		fm.car_off_id.value = car_off_id;
		fm.action="car_cash_back_bill_one_sc.jsp";
		fm.target="_self";
		fm.submit();		
	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='car_cash_back_bill_all_sc.jsp' method='post' target='t_content'>
<input type='hidden' name='st' value=''>
<input type='hidden' name='car_off_id' value=''>
<input type='hidden' name='s_car_off_id' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1280>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>HOME</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='20%'  class='title'>출고일자</td>
            <td>&nbsp;
            <!-- 
              <select name="car_off_id" id="car_off_id" >
                <option value=''>선택</option>
                <%if(vt_size2 > 0){
                    for (int i = 0 ; i < vt_size2 ; i++){
                    	Hashtable ht = (Hashtable)vt2.elementAt(i);
                %>
                <option value='<%= ht.get("CAR_OFF_ID") %>' <%if(car_off_id.equals(String.valueOf(ht.get("CAR_OFF_ID")))){%>selected<%}%>><%=c_db.getNameById(String.valueOf(ht.get("CAR_OFF_ID")),"CAR_OFF")%></option>
                <%	}
                  }
                %>
              </select>
               -->
            			&nbsp;&nbsp;&nbsp;
            			<input type='radio' name="gubun1" value='1' <%if(gubun1.equals("1")){%>checked<%}%>>월별
            			&nbsp;&nbsp;&nbsp;
						<select name="s_yy">
			  			<%for(int i=AddUtil.getDate2(1); i>=2019; i--){%>
							<option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>년</option>
						<%}%>
						</select>
	        			<select name="s_mm">
	          			<%for(int i=1; i<=12; i++){%>
	          				<option value="<%=AddUtil.addZero2(i)%>" <%if(s_mm.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>월</option>
	          			<%}%>
	        			</select>    
	        			<!-- 
	        			&nbsp;&nbsp;&nbsp;      
            			<input type='radio' name="gubun1" value='2' <%if(gubun1.equals("2")){%>checked<%}%>>기간
            			&nbsp;&nbsp;&nbsp;  
            			<input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
                        &nbsp;&nbsp;&nbsp;                               
            			<input type='radio' name="gubun1" value='3' <%if(gubun1.equals("3")){%>checked<%}%>>연체
            			-->                

                        
              &nbsp;<a href="javascript:car_Search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
            </td>
          </tr>
        </table>
      </td>
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
                    <td colspan='3' class='title'>거래처</td>
                    <td colspan='6' class='title'>수금현황</td>
                    <td colspan='6' class='title'>미수금내역</td>
                </tr>
                <tr>    
                    <td width='9%' rowspan='2' class='title'>소속사</td>
                    <td width='14%' rowspan='2' class='title'>대리점명</td>
                    <td width='7%' rowspan='2' class='title'>입금예정일</td>                    
                    <td colspan='2' class='title'>계획</td>
                    <td colspan='2' class='title'>수금</td>
                    <td colspan='2' class='title'>미수금</td>
                    <td colspan='2' class='title'>미도래금액</td>
                    <td colspan='2' class='title'>연체금액</td>
                    <td colspan='2' class='title'>합계</td>
                </tr>
                <tr>                        
                    <td width='3%' class='title'>건수</td>
                    <td width='8%' class='title'>금액</td>
                    <td width='3%' class='title'>건수</td>
                    <td width='8%' class='title'>금액</td>
                    <td width='3%' class='title'>건수</td>
                    <td width='8%' class='title'>금액</td>
                    <td width='3%' class='title'>건수</td>
                    <td width='8%' class='title'>금액</td>
                    <td width='3%' class='title'>건수</td>
                    <td width='8%' class='title'>금액</td>
                    <td width='3%' class='title'>건수</td>
                    <td width='8%' class='title'>금액</td>
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
                    <td align="center"><%=ht.get("NM")%></td>
                    <td align="center"><a href="javascript:CarStatBillOne('<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CAR_OFF_NM")%></a></td>
                    <td align="center"><%=ht.get("CASHBACK_EST_DT")%></td>
                    <td align="right"><a href="javascript:CarStatBillList('1', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT1")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('1', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('2', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT2")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('2', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('3', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT3")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('3', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT3")))%></a></td> 
                    <td align="right"><a href="javascript:CarStatBillList('4', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT4")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('4', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT4")))%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('5', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT5")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('5', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT5")))%></a></td>
                    <td align="right"><%=amt11%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt12)%></td>
                </tr>
                <%	}%>
                <tr>
                    <td class='title' colspan='4'>합계</td>
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
                    <td colspan="15" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>       
  

  </table>
</form>
</body>
</html>
