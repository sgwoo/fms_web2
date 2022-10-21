<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, acar.out_car.*"%>
<jsp:useBean id="oc_db" scope="page" class="acar.out_car.OutCarDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	if(gubun1.equals("") && st_dt.equals("") && end_dt.equals("")){
		gubun1 = "1";
	}

	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");

	//영업소 조회
	Vector vt2 = oc_db.getCarCashBackDayCd("");
	int vt_size2 = vt2.size();	
	
	String car_off_id = request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	
	//카드스케줄 리스트 조회
	Vector vt = new Vector();
	int vt_size = 0;	
	
	if(gubun1.equals("1") && car_off_id.equals("")){
		
	}else{	
		vt = oc_db.getCarPayStat(car_off_id, s_yy, s_mm, gubun1, st_dt, end_dt);
		vt_size = vt.size();	
	}
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;	
	long total_amt5 = 0;	

	
%>



<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
  function cng_car_off_id(value){
		var fm = document.form1;
		//if(fm.s_yy.value == '2018' && toInt(fm.s_mm.value) < 7){
		//	alert('2018년7월 이전 데이타는 없습니다.'); return;
		//}
		fm.action = "car_cash_back_pay_sc.jsp";
		fm.target = "_self";
		fm.submit();
  }
  
	function car_Search(){
		var fm = document.form1;
		//if(fm.s_yy.value == '2018' && toInt(fm.s_mm.value) < 7){
		//	alert('2018년7월 이전 데이타는 없습니다.'); return;
		//}
		fm.action="car_cash_back_pay_sc.jsp";
		fm.target="_self";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') car_Search();
	}	 
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='cash_back_sc.jsp' method='post' target='t_content'>
<input type='hidden' name='mode' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1280>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>영업소별수금현황</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='20%'  class='title'>거래처명</td>
            <td>&nbsp;
              <select name="car_off_id" id="car_off_id" onChange="javascript:cng_car_off_id(this.value)" >
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
            			      &nbsp;&nbsp;&nbsp;
            			<input type='radio' name="gubun1" value='1' <%if(gubun1.equals("")||gubun1.equals("1")){%>checked<%}%>>월별
            			      &nbsp;&nbsp;&nbsp;
						<select name="s_yy">
			  			<%for(int i=2019; i<=AddUtil.getDate2(1); i++){%>
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

                        
              &nbsp;<a href="javascript:car_Search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <%if(gubun1.equals("1") && car_off_id.equals("")){%>
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
                    <td width='10%' rowspan='2' class='title'>출고일자</td>
                    <td width='10%' rowspan='2' class='title'>차량번호</td>
                    <td width='10%' rowspan='2' class='title'>차명</td>
                    <td width='10%' rowspan='2' class='title'>차대번호</td>
                    <td colspan='2' class='title'>판매장려금</td>
                    <td colspan='3' class='title'>입금현황</td>
                    <td width='10%' rowspan='2' class='title'>미수금액</td>
                </tr>
                <tr>
                    <td width='9%' class='title'>적립금</td>
                    <td width='9%' class='title'>입금예정일</td>
                    <td width='9%' class='title'>입금일</td>
                    <td width='9%' class='title'>금액</td>
                    <td width='9%' class='title'>손익금액</td>
                </tr>                
                <%
                	if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            
				      				if(AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT"))) < 0){
				      					ht.put("DLY_AMT","0");				      				
				      				}

						            total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("BASE_AMT")));
					      			total_amt3 = total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("INCOM_AMT")));
					      			total_amt4 = total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
					      			total_amt5 = total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("M_AMT")));
					      			
					      %>
                <tr>
                    <td class='title'><%=i+1%></td>
                    <td class='title'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BASE_DT")))%></td>
                    <td align="center"><%=ht.get("CAR_NO")%></td>
                    <td align="center"><%=ht.get("CAR_NM")%></td>
                    <td align="center"><%=ht.get("CAR_NUM")%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("BASE_AMT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INCOM_DT")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("INCOM_AMT"))))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("M_AMT")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("DLY_AMT")))%></td>
                </tr>
                <%	}%>
                <tr>
                    <td class='title' colspan='5'>합계</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                    <td align="right">&nbsp;</td>
                    <td align="right">&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt3)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt5)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt4)%></td>
                </tr>		            
		            <%}else{%>
                <tr>
                    <td colspan="11" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>    	  
    <%}%>
  </table>
</form>
</body>
</html>
