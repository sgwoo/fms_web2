<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*,acar.user_mng.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//��ü����
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_l_cd"){
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
	}	
	
	//����ϱ�
	function save(){
		fm = document.form1;
		
		if(fm.auto_dt.value == ''){ alert('��ǥ���ڸ� �Է��Ͻʽÿ�.'); return;}
		
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("�ϰ� ó���� ���� �����ϼ���.");
			return;
		}	
				
		if(!confirm("����Ͻðڽ��ϱ�?"))	return;
		fm.action = 'debt_settle_popup_auto_a.jsp';
		fm.target = '_blank';
		fm.submit();
	}	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String chk	= request.getParameter("chk")==null?"":request.getParameter("chk");//1:�⵵ , 2:��������
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	
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
	long total_amt13 = 0;
	long total_amt14 = 0;
	long total_amt15 = 0;  //���� ��ü�� ����ݾ�
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	Vector debts = new Vector();
	
	if ( chk.equals("1")) {
		debts = 	ad_db.getDebtSettleList(gubun1, gubun2, gubun3, gubun4, s_kd, t_wd, sort_gubun, asc);
	} else {
		debts = 	ad_db.getDebtSettleList1(gubun1, gubun2, gubun3, gubun4, s_kd, t_wd, sort_gubun, asc);
	}
	
	int debt_size = debts.size();
%>
<form name='form1' action='' method="post">
<input type='hidden' name='size' value='<%=debt_size%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=2100>
	<tr> 
      <td>
        <table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1><span class=style5><%=gubun2%>�⵵ <%=gubun3%>�� ��������ä��Ȳ</span></span></td>
            <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>            
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
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
			<td width=30 rowspan="2" class='title' style='height:38'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
			<td width=30 rowspan="2" class='title' style='height:38'>����</td>
			<td width=50 rowspan="2" class='title'>����</td>		
			<td width=110 rowspan="2" class='title'>������</td>								
			<td width=100 rowspan="2" class='title'>�ŷ�ó�ڵ�</td>											
			<td width=100 rowspan="2" class='title'>����ȣ</td>			
			<td width=120 rowspan="2" class='title'>���¹�ȣ</td>
			<td width=90 rowspan="2" class='title'>������ȣ</td>
			<td width=100 rowspan="2" class='title' style='height:38'>��������</td>
			<td width=100 rowspan="2" class='title'>��ȯ�ϷΌ����</td>
			<td width=100 rowspan="2" class='title'>�ܾ�</td>
		<!-- 	<td width=100 rowspan="2" class='title'>����</td>		-->		
			
			<td colspan="13" class='title'>����ȯ�ݾ�</td>
		  </tr>
		  <tr>
			<td width=90 class='title'>�հ�</td>
			<td width=90 class='title'>1��</td>
			<td width=90 class='title'>2��</td>
			<td width=90 class='title'>3��</td>
			<td width=90 class='title'>4��</td>
			<td width=90 class='title'>5��</td>
			<td width=90 class='title'>6��</td>
			<td width=90 class='title'>7��</td>
			<td width=90 class='title'>8��</td>
			<td width=90 class='title'>9��</td>
			<td width=90 class='title'>10��</td>
			<td width=90 class='title'>11��</td>
			<td width=90 class='title'>12��</td>
		  </tr>		
		  		
<%		for(int i = 0 ; i < debt_size ; i++){
			Hashtable debt = (Hashtable)debts.elementAt(i);
			String st1 = String.valueOf(debt.get("ST1"));
			String st2 = String.valueOf(debt.get("ST2"));
			
			String lend_dt= String.valueOf(debt.get("LEND_DT")); 
			
			if (lend_dt.substring(0,4).equals(gubun2) ) continue;   //��ȯ�⵵�� ���� �߻����� ���� ( �⸻ �̿� �۾��� )
			
			
			%>
		  <tr>
		  <!--  202012�� ���� - ������Աݿ��� ������������Ա����� ��ü�� ���س⵵ ���⿩�η� ó�� ??  -->
   		    <td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='center'>   		   
   		      <input type="checkbox" name="ch_l_cd" value="<%=debt.get("ST2")%>/<%=debt.get("CPT_CD")%>/<%=debt.get("VEN_CODE")%>/<%=debt.get("AMT13")%>/<%=debt.get("LEND_ID")%>/<%=debt.get("RTN_SEQ")%>/<%=debt.get("CAR_MNG_ID")%>/<%=debt.get("RENT_L_CD")%>/<%=debt.get("DEPOSIT_NO")%>/<%=debt.get("CAR_NO")%>" 
      		    <%  if ( lend_dt.substring(0,4).equals(gubun2) )  {%> disabled <% } %>  > 
      		<!--    <input type="checkbox" name="ch_l_cd" value="<%=debt.get("ST2")%>/<%=debt.get("CPT_CD")%>/<%=debt.get("VEN_CODE")%>/<%=debt.get("AMT13")%>/<%=debt.get("LEND_ID")%>/<%=debt.get("RTN_SEQ")%>/<%=debt.get("CAR_MNG_ID")%>/<%=debt.get("RENT_L_CD")%>/<%=debt.get("DEPOSIT_NO")%>/<%=debt.get("CAR_NO")%>"  > --> 
      		   
      		   </td>		  
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='center' width=30><%=i+1%></td>
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='center' width=50><%=st2%></td>		
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='center' width=110><%=debt.get("CPT_NM")%></td>								
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='center' width=100><%=debt.get("VEN_CODE")%></td>	
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='center' width=100><%=debt.get("LEND_NO")%></td>										
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='center' width=120><%=debt.get("DEPOSIT_NO")%></td>
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='center' width=90><%=debt.get("CAR_NO")%><%if(String.valueOf(debt.get("CAR_NO")).equals("")){%><%=debt.get("LEND_ID")%><%}%></td>					
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='center' width=100><%=debt.get("LEND_DT")%></td>
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='center' width=100><%=debt.get("END_DT")%></td>	
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=90><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT14")))%></td>	
	<!-- 		<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=90><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT15")))%></td>	-->			
									
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=90><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT13")))%></td>
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=90><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT1")))%></td>
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=90><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT2")))%></td>
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=90><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT3")))%></td>
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=90><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT4")))%></td>
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=90><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT5")))%></td>
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=90><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT6")))%></td>
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=90><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT7")))%></td>
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=90><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT8")))%></td>
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=90><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT9")))%></td>
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=90><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT10")))%></td>
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=90><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT11")))%></td>
			<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=90><%=AddUtil.parseDecimalLong(String.valueOf(debt.get("AMT12")))%></td>
		  </tr>					
<%					    total_amt1   = total_amt1   + AddUtil.parseLong(String.valueOf(debt.get("AMT1")));
						total_amt2   = total_amt2   + AddUtil.parseLong(String.valueOf(debt.get("AMT2")));
						total_amt3   = total_amt3   + AddUtil.parseLong(String.valueOf(debt.get("AMT3")));
						total_amt4   = total_amt4   + AddUtil.parseLong(String.valueOf(debt.get("AMT4")));
						total_amt5   = total_amt5   + AddUtil.parseLong(String.valueOf(debt.get("AMT5")));
						total_amt6   = total_amt6   + AddUtil.parseLong(String.valueOf(debt.get("AMT6")));
						total_amt7   = total_amt7   + AddUtil.parseLong(String.valueOf(debt.get("AMT7")));
						total_amt8   = total_amt8   + AddUtil.parseLong(String.valueOf(debt.get("AMT8")));
						total_amt9   = total_amt9   + AddUtil.parseLong(String.valueOf(debt.get("AMT9")));
						total_amt10  = total_amt10  + AddUtil.parseLong(String.valueOf(debt.get("AMT10")));
						total_amt11  = total_amt11  + AddUtil.parseLong(String.valueOf(debt.get("AMT11")));
						total_amt12  = total_amt12  + AddUtil.parseLong(String.valueOf(debt.get("AMT12")));
						total_amt13  = total_amt13  + AddUtil.parseLong(String.valueOf(debt.get("AMT13")));
						total_amt14  = total_amt14  + AddUtil.parseLong(String.valueOf(debt.get("AMT14")));
						total_amt15  = total_amt15  + AddUtil.parseLong(String.valueOf(debt.get("AMT15")));
		}%>
          <tr> 
			<td colspan="10" class="title">�հ�</td>
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt14)%></td>		
		<!-- 	<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt15)%></td>	-->
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt13)%></td>
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt1)%></td>
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt2)%></td>
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt3)%></td>
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt4)%></td>
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt5)%></td>
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt6)%></td>
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt7)%></td>
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt8)%></td>
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt9)%></td>
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt10)%></td>
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt11)%></td>
			<td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt12)%></td>
		  </tr>		
		</table>
		</td>
	</tr>		
	<tr>
		<td>
		  <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��ݵ��",user_id)){%>
		  ��ǥ���� : <input type='text' name='auto_dt' size='16' class='text' value=''>('-'����) 
		  <a href="javascript:save()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
		  <%}%>
		  <a href='javascript:window.close();'><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>	
	</tr>		
</table>
</form>
</body>
</html>