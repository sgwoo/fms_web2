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

	//������ ��ȸ
	Vector vt2 = oc_db.getCarCashBackDayCd("");
	int vt_size2 = vt2.size();	
	
	String car_off_id = request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	
	//ī�彺���� ����Ʈ ��ȸ
	Vector vt = new Vector();
	int vt_size = 0;	
	
	vt = oc_db.getCarMonStat(gubun1, st_dt, end_dt);
	vt_size = vt.size();	
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
  function Search(){
		var fm = document.form1;
		if(fm.gubun1.value == '3' && toInt(fm.st_dt.value) < 20180701){
			alert('2018��7�� ���� ����Ÿ�� �����ϴ�.'); return;
		}
		if(fm.gubun1.value == '3' && ( fm.st_dt.value =='' || fm.st_dt.value =='')){
			alert('�Ⱓ�� �Է��Ͻʽÿ�.'); return;
		}
		fm.action = "car_cash_back_mon_sc.jsp";
		fm.target = "_self";
		fm.submit();
  }
  
  function CardStatBase(st, car_off_id){
		var fm = document.form1;
		fm.st.value = st;
		fm.car_off_id.value = car_off_id;
		fm.action = "car_cash_back_mon_list.jsp";
		window.open("about:blank", "CardMonList", "left=350, top=50, width=1000, height=800, scrollbars=yes, status=yes");
		fm.target = "CardMonList";
		fm.submit();
  }
   
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='car_cash_back_mon_sc.jsp' method='post' target='t_content'>
<input type='hidden' name='st' value=''>
<input type='hidden' name='car_off_id' value=''>	
  <table border="0" cellspacing="0" cellpadding="0" width=1280>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������Ȳ</span></td>
	  </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=1>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gjij.gif align=absmiddle>
						            <select name='gubun1'>
                          <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>���</option>
                          <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>����</option>
                          <option value="3" <%if(gubun1.equals("3")){%>selected<%}%>>�Ⱓ</option>
                        </select>
            			      &nbsp;&nbsp;&nbsp;
            			      <input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
            			      &nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
					</td>
                </tr>
            </table>
        </td>
    </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='10%'  class='title'>����</td>
                    <td width='30%' class='title'>�ŷ�ó</td>
                    <td width='30%' class='title'>�߻��ݾ�</td>
                    <td width='30%' class='title'>������ ���ݾ�</td>                    
                </tr>
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            
					            total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
				      			total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
		        %>
                <tr>
                    <td class='title'><%=i+1%></td>
                    <td align="center"><%=ht.get("CAR_OFF_NM")%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%><a href="javascript:CardStatBase('1', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"></a></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%><a href="javascript:CardStatBase('2', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"></a></td>
                </tr>
		            <%	}%>
                <tr>
                    <td class='title' colspan='2'>�հ�</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt2)%></td>
                </tr>		            
		            <%}else{%>
                <tr>
                    <td colspan="4" align="center">��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>
  </table>
</form>
</body>
</html>
