<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.bill_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>�ŷ�ó �˻�</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function Search(){
		var fm = document.form1;
		fm.action = "vendor_list.jsp";
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') document.form1.submit();
	}

	function setVendor(ven_code, ven_name, ven_nm_cd, ve_st){
		var fm = opener.document.form1;
		fm.n_ven_code.value = ven_code;
		fm.n_ven_name.value = ven_name;	
		fm.n_ven_nm_cd.value = ven_nm_cd;		
		if (ve_st == '1') {
		
		//    fm.ven_st[0].checked = true;
		//    fm.ven_st[1].checked = false;
		//    fm.ven_st[2].checked = false;
		//    fm.ven_st[3].checked = false;
		  //  fm.ven_st[0].disabled = true;
		  //  fm.ven_st[1].disabled = true;
		  //  fm.ven_st[2].disabled = true;
		  //  fm.ven_st[3].disabled = true;
		}
		
		if (ve_st == '2') {
		
		 //   fm.ven_st[0].checked = false;
		 //   fm.ven_st[1].checked = true;
		 //   fm.ven_st[2].checked = false;
		 //   fm.ven_st[3].checked = false;
		 //   fm.ven_st[0].disabled = true;
		 //   fm.ven_st[1].disabled = true;
		 //   fm.ven_st[2].disabled = true;
		 //   fm.ven_st[3].disabled = true;
		}
		if (ve_st == '3') {
		
		//    fm.ven_st[0].checked = false;
		//    fm.ven_st[1].checked = false;
		//    fm.ven_st[2].checked = true;
		//    fm.ven_st[3].checked = false;
		//    fm.ven_st[0].disabled = true;
		//    fm.ven_st[1].disabled = true;
		//    fm.ven_st[2].disabled = true;
		//    fm.ven_st[3].disabled = true;
		}
		if (ve_st == '4') {
		
		 //   fm.ven_st[0].checked = false;
		 //   fm.ven_st[1].checked = false;
		 //   fm.ven_st[2].checked = false;
		 //   fm.ven_st[3].checked = true;
		//    fm.ven_st[0].disabled = true;
		 //   fm.ven_st[1].disabled = true;
		//    fm.ven_st[2].disabled = true;
		//    fm.ven_st[3].disabled = true;
		}
				
		if(ven_name.indexOf('��ü��') != -1 || ven_name.indexOf('�ü���������') != -1) fm.ven_st[3].checked = true;
			
		window.close();
	}
		
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:document.form1.t_wd.focus();">
<%
	String idx 	= request.getParameter("idx")==null?"":request.getParameter("idx");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String ven_st = "";

	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	t_wd = AddUtil.replace(t_wd,"'","");
	
	//�ŷ�ó����
	TradeBean[] vens = neoe_db.getBaseTradeList(s_kd, t_wd);
	int ven_size = vens.length;
%>
<form name='form1' method='post' action='vendor_list.jsp'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='ven_code' value=''>
<input type='hidden' name='ven_name' value=''>
<input type='hidden' name='ven_nm_cd' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
      <td align='left'>
      &nbsp;&nbsp;<img src=/acar/images/center/arrow_glc.gif align=absmiddle>&nbsp;

        <input type='text' name='t_wd' size='30' value='<%=t_wd%>' class='text' onKeyDown='javascript:enter()'>

        &nbsp;<a href="javascript:document.form1.submit()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a> 
		&nbsp;&nbsp;
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='5%' class='title'>����</td>
            <td width="5%" class='title'>����</td>			
            <td width="8%" class='title'>��������</td>						
            <td width="12%" class='title'>����ڹ�ȣ</td>
            <td width="28%" class='title'>�ŷ�ó��</td>			
            <td width="28%" class='title'>�ּ�</td>						
            <td width="7%" class='title'>����</td>						
            <td width="7%" class='title'>�̷�</td>									
          </tr>
                <%if(ven_size > 0 && !t_wd.equals("")){
						for(int i = 0 ; i < ven_size ; i++){
							TradeBean ven = vens[i];	
							
							ven_st  = c_db.getTradeHisVenSt(ven.getCust_code());//trade_his����
							if(ven_st.equals("")){
								ven_st  = c_db.getCardDocVenSt(ven.getCust_code());//card_doc����
							}
				%>
          <tr> 
            <td align="center"><%=i+1%></td>
            <td align="center"><%if(ven.getMd_gubun().equals("N")){%>����<%}else{%>����<%}%></td>			
            <td align="center"><%if(ven_st.equals("1")){%>�Ϲݰ���<%}else if(ven_st.equals("2")){%>���̰���<%}else if(ven_st.equals("3")){%>�鼼<%}else if(ven_st.equals("4")){%>�񿵸�����(�������/��ü)<%}else{%><%=ven_st%><%}%></td>						
            <td align="center"><a href="javascript:setVendor('<%= ven.getCust_code()%>','<%= AddUtil.replace(ven.getCust_name(),"'","")%>','<%= ven.getS_idno()%>', '<%=ven_st%>' );"><%= ven.getS_idno()%></a></td>
            <td>&nbsp;<a href="javascript:setVendor('<%= ven.getCust_code()%>','<%= AddUtil.replace(ven.getCust_name(),"'","")%>','<%= ven.getS_idno()%>', '<%=ven_st%>' );"><%= ven.getCust_name()%>&nbsp;<%if(!ven.getDc_rmk().equals("")){%>(<%= ven.getDc_rmk()%>)<%}%></a></td>            
            <td>&nbsp;<span title='<%=ven.getS_address()%>'><%=Util.subData(ven.getS_address(), 30)%></span></a></td>			
            <td align="center"><!--<a href="javascript:Update('<%= ven.getCust_code()%>','<%= AddUtil.replace(ven.getCust_name(),"'","")%>','<%= ven.getS_idno()%>', '<%=ven_st%>' );"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>--></td>            			
            <td align="center"><!--<a href="javascript:History('<%= ven.getCust_code()%>' );"><img src=/acar/images/center/button_in_ir.gif align=absmiddle border=0></a>-->
	  </td>            						
          </tr>
                <%	}
				}%>		  
        </table>
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
      <td align='right'><!--<a href="javascript:Save();"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>-->&nbsp; 
      	<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
     <tr> 
      <td align='left'>&nbsp;&nbsp;&nbsp;<font color=red>�� ��ȣ�� ���� ��� ī����ǥ�� ����ڹ�ȣ�� �ݵ�� Ȯ���ϼż� ��Ȯ�ϰ� �Է��ϼž� �մϴ�. <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ΰ��� �Ű� �� ȸ��ó���� ������ �ֽ��ϴ�.</font> 
     </td>
    </tr>
  </table>
</form>
</body>
</html>