<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, acar.out_car.*"%>
<jsp:useBean id="oc_db" scope="page" class="acar.out_car.OutCarDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//������ ��ȸ
	Vector vt2 = oc_db.getCarCashBackDayCd("");
	int vt_size2 = vt2.size();	
		
	String car_off_id = request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");	
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String s_sort = request.getParameter("s_sort")==null?"1":request.getParameter("s_sort");
	
	//ī�彺���� ����Ʈ ��ȸ
	Vector vt = new Vector();
	int vt_size = 0;	
	
	if(!s_dt.equals("")){
		vt = oc_db.getCarPayebillStat(car_off_id, s_dt, s_sort);
		vt_size = vt.size();	
	}
	
	long total_amt0 = 0;
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;	
	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function car_Search(){
		var fm = document.form1;
		fm.action="car_cash_back_payebill_sc.jsp";
		fm.target="_self";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') car_Search();
	}	 
	
	function Save(){
		var fm = document.form1;
		
		if(!confirm("�Ա�ǥ�� �����Ͻðڽ��ϱ�?"))	return;
		fm.action = "car_cash_back_payebill_sc_a.jsp";
		//fm.target = "i_no";
		fm.target = "_self";
		fm.submit();		
	}
	
	//��ü����
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
	}			
	  
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='t_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='from_page' value='/card/cash_back/card_incom_sc.jsp'>

  <table border="0" cellspacing="0" cellpadding="0" width=900>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ա�ǥ����</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='15%'  class='title'>�ŷ�ó��</td>
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
              &nbsp;&nbsp;&nbsp;&nbsp;
              �Ա����� : <input name="s_dt" type="text" class="text" value="<%=s_dt%>" size="12" onKeyDown="javasript:enter()" style='IME-MODE: active'>              
              &nbsp;&nbsp;&nbsp;&nbsp;
              1�������� : <select name="s_sort" id="s_sort">
                <option value='1' <%if("s_sort".equals("1")){%>selected<%}%>>�Ա�����</option>
                <option value='2' <%if("s_sort".equals("2")){%>selected<%}%>>�ŷ�ó</option>
              </select>              
              &nbsp;<a href="javascript:car_Search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <%if(!s_dt.equals("")){%>
    <tr> 
        <td class=h></td>
    </tr>	
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='15%' class='title'>����</td>
                    <td width='30%' class='title'>�ŷ�ó</td>
                    <td width='18%' class='title'>�Ա�����</td>
                    <td width='10%' class='title'>�Ǽ�</td>
                    <td width='17%' class='title'>�Աݱݾ�</td>
                    <td width='10%' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
                </tr>                
                <%
                	if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					      %>
                <tr>
                    <td class='title' align="center"><%=i+1%></td>
                    <td>&nbsp;<%=ht.get("CAR_OFF_NM")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INCOM_DT")))%></td> 
                    <td align="center"><%=ht.get("CNT")%></td>                   
                    <td align="center"><input type="text" name="incom_amt" size="12" value="<%=AddUtil.parseDecimalLong(String.valueOf(ht.get("INCOM_AMT")))%>" class=whitenum readonly>��</td>
                    <td align="center"><input type="checkbox" name="ch_cd" value="<%=ht.get("CAR_OFF_ID")+""+ht.get("INCOM_DT")%>"></td>
                </tr>
		            <%	}%>
		            <%}%>
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>    
    <tr> 
      <td align="right">
        <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�Աݴ��",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) || nm_db.getWorkAuthUser("ī��ĳ������",user_id)){%>        
        <a href="javascript:Save();"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
        <%}%>
      </td>
    </tr>    
    <%}%>  
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
