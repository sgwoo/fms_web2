<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.bill_mng.*, acar.tint.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.debt.DebtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String idx 	= request.getParameter("idx")==null?"":request.getParameter("idx");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String t_wd2 = request.getParameter("t_wd2")==null?"":request.getParameter("t_wd2");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String ven_st = "";
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	t_wd = AddUtil.replace(t_wd,"'","");
	
	//�ŷ�ó����
	TradeBean[] vens = neoe_db.getBaseTradeSidnoSearchList(s_kd, t_wd, t_wd2);//-> neoe_db ��ȯ
	int ven_size = vens.length;
%>


<html>
<head><title>�ŷ�ó �˻�</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//	document.domain = "amazoncar.co.kr";
	
	function Search(){
		var fm = document.form1;
		if(fm.t_wd.value == ''){ alert('�˻��� ����ڹ�ȣ�� �����ϴ�.'); return;}
		fm.action = "vendor_list.jsp";
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') document.form1.submit();
	}

	function setVendor(ven_code, ven_name, ven_nm_cd, ve_st, off_id){
		var fm = opener.document.form1;
		
		
			fm.ven_code.value 	= ven_code;
			fm.ven_name.value 	= ven_name;	
			fm.ven_nm_cd.value 	= ven_nm_cd;
			fm.ve_st.value = ve_st;
			fm.off_id.value = off_id;
					
			
			window.close();			

	}
	
	//����ϱ�
	function Save(){
		var fm = document.form1;
		fm.action = "vendor_reg.jsp";
		fm.submit();
	}	
	
	//�����ϱ�
	function Update(ven_code, ven_name, ven_nm_cd, ve_st){
		var fm = document.form1;
		fm.ven_code.value = ven_code;
		fm.ven_name.value = ven_name;	
		fm.ven_nm_cd.value = ven_nm_cd;			
		fm.action = "vendor_upd.jsp";
		fm.submit();					
	}	
	
	//�ŷ�ó �̷º���
	function History(ven_code){
		var fm = document.form1;
		//window.open("../doc_reg/vendor_carddoc_nowyear_history.jsp?ven_code="+ven_code, "VENDOR_H_LIST", "left=10, top=10, width=1050, height=600, scrollbars=yes");				
		window.open("../doc_reg/vendor_history.jsp?ven_code="+ven_code, "VENDOR_H_LIST", "left=10, top=10, width=1050, height=600, scrollbars=yes");				
	}
	//ī����ǥ�̷º���
	function CardDocHistory(ven_code){
		var fm = document.form1;
		window.open("../doc_reg/vendor_carddoc_history.jsp?ven_code="+ven_code, "VENDOR_DOC_LIST", "left=10, top=10, width=950, height=600, scrollbars=yes");				
	}		
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:document.form1.t_wd.focus();">
<form name='form1' method='post' action='vendor_list.jsp'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='ven_code' value=''>
<input type='hidden' name='ven_name' value=''>
<input type='hidden' name='ven_nm_cd' value=''>
<input type='hidden' name='off_id' value=''>
<input type='hidden' name='from_page' value='<%=from_page%>'>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
      <td align='left'>
      &nbsp;&nbsp;<img src=/acar/images/center/arrow_glc.gif align=absmiddle>&nbsp;
	  <!--
        <select name="s_kd">
          <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>�ŷ�ó��</option>
          <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>����ڹ�ȣ</option>				
        </select>	-->
        <input type='text' name='t_wd' size='30' value='<%=t_wd%>' class='text' onKeyDown='javascript:enter()'>

        &nbsp;<a href="javascript:document.form1.submit()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a> 
		&nbsp;&nbsp;
		(����ڹ�ȣ�θ� �˻��˴ϴ�.)
      </td>
    </tr>
    <tr>
      <td align='left'>
      &nbsp;&nbsp;* �������˻� : <input type='text' name='t_wd2' size='30' value='<%=t_wd2%>' class='text' onKeyDown='javascript:enter()'> (�ŷ�ó��)
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
						//��������
						Hashtable off_ht = t_db.getSearchOff_id(ven.getS_idno());
				%>
          <tr> 
            <td align="center"><%=i+1%></td>
            <td align="center"><%if(ven.getMd_gubun().equals("N")){%>����<%}else{%>����<%}%></td>			
            <td align="center"><%if(ven_st.equals("1")){%>�Ϲݰ���<%}else if(ven_st.equals("2")){%>���̰���<%}else if(ven_st.equals("3")){%>�鼼<%}else if(ven_st.equals("4")){%>�񿵸�����(�������/��ü)<%}else{%><%=ven_st%><%}%></td>						
            <td align="center"><a href="javascript:setVendor('<%= ven.getCust_code()%>','<%= AddUtil.replace(ven.getCust_name(),"'","")%>','<%= ven.getS_idno()%>', '<%=ven_st%>', '<%=off_ht.get("OFF_ID")%>' );" title='�ŷ�ó ����'><%= ven.getS_idno()%></a></td>
            <td>&nbsp;<a href="javascript:setVendor('<%= ven.getCust_code()%>','<%= AddUtil.replace(ven.getCust_name(),"'","")%>','<%= ven.getS_idno()%>', '<%=ven_st%>', '<%=off_ht.get("OFF_ID")%>' );" title='�ŷ�ó ����'><%= ven.getCust_name()%>&nbsp;<%= ven.getDname()%>&nbsp;<%if(!ven.getDc_rmk().equals("")){%>(<%= ven.getDc_rmk()%>)<%}%></a></td>            
            <td>&nbsp;<span title='<%=ven.getS_address()%>'><%=Util.subData(ven.getS_address(), 30)%></span></a></td>			
            <td align="center"><a href="javascript:Update('<%= ven.getCust_code()%>','<%= AddUtil.replace(ven.getCust_name(),"'","")%>','<%= ven.getS_idno()%>', '<%=ven_st%>' );" title='�ŷ�ó �����ϱ�'><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a></td>            			
            <td align="center"><a href="javascript:History('<%= ven.getCust_code()%>' );" title='�ŷ�ó ���� �̷� ����'><img src=/acar/images/center/button_in_ir.gif align=absmiddle border=0></a>
			
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
      <td align='right'><a href="javascript:Save();"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp; 
      	<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
     <tr> 
      <td align='left'>&nbsp;&nbsp;&nbsp;<font color=red>�� ī����ǥ�� ����ڹ�ȣ�� �ݵ�� Ȯ���ϼż� ��Ȯ�ϰ� �Է��ϼž� �մϴ�. <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ΰ��� �Ű� �� ȸ��ó���� ������ �ֽ��ϴ�.</font> 
     </td>
    </tr>
  </table>
</form>
</body>
</html>