<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=popup_asset_s11_excel.xls");
%>
<%@ page import="java.util.*, acar.asset.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
</script>

<body>
<%  String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String st 	= request.getParameter("st")==null?"1":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"car_no":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	String st_nm = "";
	
	if (st.equals("1") ) {
		st_nm = "��������";
	} else {
		st_nm = "�뿩����";
	}
	
	
	AssetDatabase a_db = AssetDatabase.getInstance();
	
	Vector vt = new Vector();
	
	vt = a_db.getAssetList11(st, gubun, gubun_nm, "2012");

	int cont_size = vt.size();
	
	long t_amt1[] = new long[1];  //���ʰ���
    long t_amt2[] = new long[1];  //��� ����
    long t_amt3[] = new long[1];  //���� ����
    long t_amt4[] = new long[1];  // ��� ����
    long t_amt5[] = new long[1];  //���� ����
    long t_amt6[] = new long[1];  //���⸻ ����
    long t_amt7[] = new long[1];  //��⸻�� ��ΰ���
    long t_amt8[] = new long[1];
    long t_amt9[] = new long[1];
    long t_amt10[] = new long[1];  //�Ű���
    
    String ass_dt = "";
	
%>
<table border="1" cellspacing="0" cellpadding="0" width=1700>
  <tr> 
    <td colspan="18" align="left"><font face="����" size="4" > 
      <b>����: <%=st_nm%> </b> </font></td>
  </tr>
  <tr align="center"> 
    <td width='7%' >����</td>
    <td width='12%' >�ڻ��ڵ�</td>
    <td width='28%' >�ڻ��</td>
    <td width='18%' >������ȣ</td>
    <td width="15%" >�������</td>
    <td width="3%" >���뿬��</td>
    <td width="4%"  >����</td>
    <td width="10%" >���ʰ���</td>
	<td width="10%" >���⸻����</td>	
	<td width="10%" >�������</td>	
	<td width="10%" >��������</td>			  
	<td width='10%' >��Ⱘ��</td>
	<td width='10%' >���ݰ���</td>
	<td width="10%" >�Ϲݻ󰢾�</td>		
	<td width="10%" >��⸻����</td>		 
	<td width="10%" >��⸻��ΰ���</td>	
	<td width="10%" >�󰢿ϷῩ��</td>
	<td width="10%" >ó������</td>
	<td width="10%" >ó�бݾ�</td>
	
   </tr>
  <%
   	if(cont_size > 0){
		for(int i = 0 ; i < cont_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);		
						
			long t1=0;
			long t2=0;
			long t3=0;
			long t4=0;
			long t5=0;
			long t6=0;
			long t7=0;
			long t8=0;
			long t9=0;
			long t10=0;
											
			if (String.valueOf(ht.get("GET_DATE")).substring(0,4).equals(String.valueOf(ht.get("GISU")))) {
			  t1 = 0;
			  t2 = AddUtil.parseLong(String.valueOf(ht.get("GET_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("BOOK_DR")));
          	} else {
              t1 = AddUtil.parseLong(String.valueOf(ht.get("GET_AMT")));
              t2 = AddUtil.parseLong(String.valueOf(ht.get("BOOK_DR")));
          	} 
			
							
			t4=AddUtil.parseLong(String.valueOf(ht.get("BOOK_CR")));
			t6=AddUtil.parseLong(String.valueOf(ht.get("JUN_RESER")));
			t8=AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT")));
			
			t10=AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));
			
			if ( ht.get("DEPRF_YN").equals("5")) {
				t5=AddUtil.parseLong(String.valueOf(ht.get("JUN_RESER")))+ AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT")));
				t7 = 0;
				t9 = 0;
			} else {
				t7 = t1 + t2 - t6 - t8;
				t9 = t6 + t8;
			}
			
					
			for(int j=0; j<1; j++){
			
					t_amt1[j] += t1;
					t_amt2[j] += t2;
					t_amt3[j] += t3;
					t_amt4[j] += t4;
					t_amt5[j] += t5;
					t_amt6[j] += t6;
					t_amt7[j] += t7;
					t_amt8[j] += t8;
					t_amt9[j] += t9;
					t_amt10[j] += t10;
													
			}
		
		%>			
  <tr> 
     <td width='7%' align='center'><%=i+1%></td>
     <td width='12%' align='center'><%=ht.get("ASSET_CODE")%></td>
     <td width='28%' align='center'>&nbsp;<%=ht.get("ASSET_NAME")%></td>
     <td width='18%' align='center'><%=ht.get("CAR_NO")%></td>		
     <td width='15%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("GET_DATE")))%></td>
     <td width='3%' align='center'>5</td>
     <td width="4%" align='right'>0.2&nbsp;</td>
     <td width='10%' align='right'><%=Util.parseDecimal(t1)%></td>
	 <td width='10%' align='right'><%=Util.parseDecimal(t6)%></td>		
	 <td width='10%' align='right'><%=Util.parseDecimal(t2)%></td>					
	 <td width='10%' align='right'><%=Util.parseDecimal(t3)%></td>
	 <td width='10%' align='right'><%=Util.parseDecimal(t4)%></td>
	 <td width='10%' align='right'><%=Util.parseDecimal(t5)%></td>
	 <td width='10%' align='right'><%=Util.parseDecimal(t8)%></td>	
	 <td width='10%' align='right'><%=Util.parseDecimal(t9)%></td>		  
	 <td width='10%' align='right'><%=Util.parseDecimal(t7)%></td>
	 <td width='10%' align='right'>
    <%    if (ht.get("DEPRF_YN").equals("1")){%>�󰢺Ұ� <%}else if( ht.get("DEPRF_YN").equals("2")){%>������  <%}else if( ht.get("DEPRF_YN").equals("4")){%>�󰢿Ϸ�  <%}else if( ht.get("DEPRF_YN").equals("5")){%>���ó�� <%}else if( ht.get("DEPRF_YN").equals("6")){%>ó�� <%}%>&nbsp;  
   </td> 
    <td>
    <% if (  ht.get("DEPRF_YN").equals("5") ) {
         ass_dt = a_db.getMove_dt(String.valueOf(ht.get("ASSET_CODE")));
     }  %>    
    <%=ass_dt%>       
    </td>
    <td><%=Util.parseDecimal(t10)%></td> 
  </tr>
<%		}	
 }
%>
  <tr> 
  
    <td colspan=7 align="center">���հ�</td>
    <td><%=Util.parseDecimal(t_amt1[0])%></td>
	<td><%=Util.parseDecimal(t_amt6[0])%></td>	
	<td><%=Util.parseDecimal(t_amt2[0])%></td>					
	<td><%=Util.parseDecimal(t_amt3[0])%></td>
	<td><%=Util.parseDecimal(t_amt4[0])%></td>
	<td><%=Util.parseDecimal(t_amt5[0])%></td>
	<td><%=Util.parseDecimal(t_amt8[0])%></td>		  
	<td><%=Util.parseDecimal(t_amt9[0])%></td>		
	<td><%=Util.parseDecimal(t_amt7[0])%></td>
	<td></td>
	<td></td>
	<td><%=Util.parseDecimal(t_amt10[0])%></td>
  </tr>
</table>
</body>
</html>
