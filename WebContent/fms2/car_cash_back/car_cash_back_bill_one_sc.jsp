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
	
	//ī��� ����Ʈ
	Vector vt2 = oc_db.getCarCashBackDayCd("");
	int vt_size2 = vt2.size();	
	
	String car_off_id = request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	
	//ī�彺���� ����Ʈ ��ȸ
	Vector vt = new Vector();
	int vt_size = 0;	
	
	String mode = "";
	
	if(gubun1.equals("1") && car_off_id.equals("")){
		
	}else{	
		mode = "one_stat";
		vt = oc_db.getCarCashBackBillStat(car_off_id, s_yy, s_mm);
		vt_size = vt.size();	
	}	
		
	//�ŷ�ó����Ȳ
	//if(gubun1.equals("1") && !car_off_id.equals("")){
	//	mode = "one_stat";
	//	vt = oc_db.getCarCashBackBillStat(car_off_id, s_yy, s_mm);
	//	vt_size = vt.size();
	//}	
	//��ü��Ȳ
	//if(gubun1.equals("3")){	
	//	mode = "dly_stat";
	//	vt = oc_db.getCarCashBackDlyStat();
	//	vt_size = vt.size();	
	//}
	//������Ȳ
	//if(mode.equals("")){
	//	mode = "all_stat";
	//	vt = oc_db.getCarCashBackBillStat(car_off_id, s_yy, s_mm, gubun1, st_dt, end_dt);
	//	vt_size = vt.size();
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
		fm.action="car_cash_back_bill_one_sc.jsp";
		fm.target="_self";
		fm.submit();
	}
	
	function CarStatBillList(st, car_off_id){
		var fm = document.form1;
		fm.s_car_off_id.value = car_off_id;
		fm.st.value = st;
		fm.action = "car_cash_back_bill_list.jsp";
		window.open("about:blank", "CarBaseList", "left=350, top=50, width=1100, height=800, scrollbars=yes, status=yes");
		fm.target = "CarBaseList";
		fm.submit();
	}	
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='car_cash_back_bill_one_sc.jsp' method='post' target='t_content'>
<input type='hidden' name='st' value=''>
<input type='hidden' name='s_car_off_id' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1280>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������Ȳ</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='20%'  class='title'>�ŷ�ó��</td>
            <td>&nbsp;
              <select name="car_off_id" id="car_off_id" >
                <option value=''>����</option>
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
            			<input type='radio' name="gubun1" value='1' <%if(gubun1.equals("1")){%>checked<%}%>>����
            			&nbsp;&nbsp;&nbsp;
						<select name="s_yy">
			  			<%for(int i=AddUtil.getDate2(1); i>=2019; i--){%>
							<option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>��</option>
						<%}%>
						</select>
	        			<select name="s_mm">
	          			<%for(int i=1; i<=12; i++){%>
	          				<option value="<%=AddUtil.addZero2(i)%>" <%if(s_mm.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
	          			<%}%>
	        			</select>    
	        			<!-- 
	        			&nbsp;&nbsp;&nbsp;      
            			<input type='radio' name="gubun1" value='2' <%if(gubun1.equals("2")){%>checked<%}%>>�Ⱓ
            			&nbsp;&nbsp;&nbsp;  
            			<input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
                        &nbsp;&nbsp;&nbsp;      
            			<input type='radio' name="gubun1" value='3' <%if(gubun1.equals("3")){%>checked<%}%>>��ü
            			 -->                

                        
              &nbsp;<a href="javascript:car_Search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <%if(gubun1.equals("1") && car_off_id.equals("")){%>
    <%}else{%>    
    <tr> 
        <td class=h></td>
    </tr>	
    <tr><td class=line2></td></tr>    
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td colspan='3' rowspan='2' class='title'>����</td>
                    <td colspan='2' class='title'>��ȹ</td>
                    <td colspan='2' class='title'>����</td>
                    <td colspan='2' class='title'>�̼���</td>
                </tr>
                <tr>
                    <td width='8%' class='title'>�Ǽ�</td>
                    <td width='12%' class='title'>�ݾ�</td>
                    <td width='8%' class='title'>�Ǽ�</td>
                    <td width='12%' class='title'>�ݾ�</td>
                    <td width='8%' class='title'>�Ǽ�</td>
                    <td width='12%' class='title'>�ݾ�</td>
                </tr>                
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
				%>
                <tr>
                    <td rowspan='7' class='title' width='20%'><%=c_db.getNameById(String.valueOf(ht.get("CAR_OFF_ID")),"CAR_OFF")%></td>
                    <td rowspan='3' class='title' width='6%'>����<br>�̿�</td>
                    <td class='title' width='11%'>�������</td>
                    <td align="right"><a href="javascript:CarStatBillList('1', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT1")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('1', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('2', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT2")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('2', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('3', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT3")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('3', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT3")))%></a></td>                    
                </tr>             
                <tr>
                    <td class='title' width='10%'>��ü</td>
                    <td align="right"><a href="javascript:CarStatBillList('4', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT4")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('4', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT4")))%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('5', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT5")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('5', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT5")))%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('6', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT6")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('6', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT6")))%></a></td>                    
                </tr>                              
                <tr>
                    <td class='title' width='10%'>�Ұ�</td>
                    <td align="right"><a href="javascript:CarStatBillList('7', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT7")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('7', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT7")))%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('8', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT8")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('8', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT8")))%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('9', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT9")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('9', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT9")))%></a></td>                    
                </tr>  
                <tr>
                    <td rowspan='3' class='title' width='5%'>���<br>���</td>
                    <td class='title' width='10%'>�������</td>
                    <td align="right"><a href="javascript:CarStatBillList('10', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT10")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('10', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT10")))%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('11', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT11")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('11', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT11")))%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('12', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT12")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('12', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT12")))%></a></td>                    
                </tr>             
                <tr>
                    <td class='title' width='10%'>�Ϳ�����</td>
                    <td align="right"><a href="javascript:CarStatBillList('13', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT13")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('13', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT13")))%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('14', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT14")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('14', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT14")))%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('15', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT15")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('15', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT15")))%></a></td>                    
                </tr>                              
                <tr>
                    <td class='title' width='10%'>�Ұ�</td>
                    <td align="right"><a href="javascript:CarStatBillList('16', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT16")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('16', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT16")))%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('17', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT17")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('17', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT17")))%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('18', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT18")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('18', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT18")))%></a></td>                    
                </tr>  
                <tr>
                    <td colspan='2' class='title'>�հ�</td>
                    <td align="right"><a href="javascript:CarStatBillList('19', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT19")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('19', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT19")))%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('20', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT20")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('20', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT20")))%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('21', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CNT21")%></a></td>
                    <td align="right"><a href="javascript:CarStatBillList('21', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT21")))%></a></td>                    
                </tr>                  
		        <%			}%>
                           
		        <%}%>
            </table>
	    </td>
    </tr>	
    <%
  		//ī��⺻��Ȳ ��ȸ
  		Vector vt3 = oc_db.getCarCashBackContStat(car_off_id);
  		int vt_size3 = vt3.size();
    %>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������Ȳ</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>    
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' rowspan='2' class='title'>����</td>
                    <td colspan='2' class='title'>�ŷ�ó</td>
                    <td colspan='2' class='title'>�Ǹ������ ����</td>
                    <td colspan='2' class='title'>�Ǹ������ ����</td>
                    <td colspan='2' class='title'>����ó</td>
                </tr>
                <tr>
                    <td width='10%' class='title'>�Ҽӻ��</td>
                    <td width='25%' class='title'>�븮��</td>
                    <td width='15%' class='title'>�������</td>
                    <td width='5%' class='title'>����</td>
                    <td width='10%' class='title'>����</td>
                    <td width='10%' class='title'>������</td>
                    <td width='10%' class='title'>�����</td>
                    <td width='10%' class='title'>��ȭ</td>
                </tr>                                
                <%if(vt_size3 > 0){
				            for (int i = 0 ; i < vt_size3 ; i++){
					            Hashtable ht = (Hashtable)vt3.elementAt(i);
				%>
                <tr>
                    <td class='title'><%=i+1%></td>
                    <td align="center"><%=ht.get("NM")%></td>
                    <td align="center"><%=ht.get("CAR_OFF_NM")%></td>
                    <td align="center">�Ǹż���(�Ҽӻ翡�� ����)</td>
                    <td align="center"><%=ht.get("CASHBACK_PER")%>%</td>
                    <td align="center">�������</td>
                    <td align="center"><%=ht.get("CASHBACK_EST_DT")%></td>
                    <td align="center"><%=ht.get("PO_AGNT_NM")%></td>
                    <td align="center"><%=ht.get("PO_AGNT_O_TEL")%></td>
                </tr>                  
	            <%	}%>
	            <%}%>
            </table>
	    </td>
    </tr>
    <%}%>
  </table>
</form>
</body>
</html>
