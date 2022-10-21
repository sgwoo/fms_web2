<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.account.AccountDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_incom_pay");
	
	Vector vt = new Vector();
	int vt_size = 0;
	
	vt = ac_db.getStatIncomPay("", "I", save_dt);
	vt_size = vt.size();
	
	String reg_dt		= "";
	if(vt.size()>0){
		for(int i=0; i<vt.size(); i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			reg_dt			= String.valueOf(ht.get("SAVE_DT"));
		}
	}
	
	String grt_nm[]	 	= new String[4];
	grt_nm[0] = "������";
	grt_nm[1] = "������";
	grt_nm[2] = "���ô뿩��";
	grt_nm[3] = "�°������";
	
	String etc_nm[]	 	= new String[3];
	etc_nm[0] = "����Ʈ";
	etc_nm[1] = "�������";
	etc_nm[2] = "������";	

	String etc_nm2[]	 = new String[3];
	etc_nm2[0] = "���������";
	etc_nm2[1] = "���·�";
	etc_nm2[2] = "��å��";

	
   	long amt1[]	 			= new long[6];
	long amt2[]	 			= new long[6];
	long amt3[]	 			= new long[6];
	long amt4[]	 			= new long[6];
	long amt5[]	 			= new long[6];
	
   	int cnt1[]	 			= new int[6];
	int cnt2[]	 			= new int[6];
	int cnt3[]	 			= new int[6];
	int cnt4[]	 			= new int[6];
	int cnt5[]	 			= new int[6];
	
	int idx = 0;
	
	String gubun1 = "";
	String gubun2 = "";
	String gubun3 = "";
	
	String row1_yn ="";
	String row2_yn ="";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//���ϸ���
	function save(){
		var fm = document.form1;	
		fm.target = 'i_no';
		fm.action = '/acar/admin/stat_end_null_200911.jsp';		
		fm.submit();	
	}
	

//-->
</script>
</head>

<body leftmargin=15>

<form name='form1' method='post' action='incoming_magam'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='mode' value='30'>
<input type='hidden' name='from_page' value='/acar/account/incoming_magam.jsp'>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='gubun3' value=''>
<input type='hidden' name='gubun4' value='1'>
<input type='hidden' name='s_kd' value=''>
<input type='hidden' name='t_wd' value=''>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > <span class=style5>����������Ȳ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr> 
        <td align="right"><img src=../images/center/arrow_gji.gif border=0 align=absmiddle> : <%=AddUtil.ChangeDate2(reg_dt)%></td>
    </tr>
	
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩�� ��Ȳ</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width="16%" colspan="3" rowspan="2" align="center" class='title'>����</td>
                    <td colspan="2" width="21%" class='title' align="center">���</td>
                    <td colspan="2" width="21%" class='title' align="center">����</td>
                    <td colspan="2" width="21%" class='title' align="center">��ü</td>
                    <td colspan="2" width="21%" class='title' align="center">�հ�(����+��ü)</td>
                </tr>
                <tr align="center"> 
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                </tr>
          		<%	idx = 0;
				if(vt.size()>0){
					for(int i=0; i<vt.size(); i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						if(String.valueOf(ht.get("GUBUN_NM")).equals("�뿩��")){
							cnt1[idx] = cnt1[idx] + AddUtil.parseInt((String)ht.get("MON_CNT"));
							cnt2[idx] = cnt2[idx] + AddUtil.parseInt((String)ht.get("DAY_CNT"));
							cnt3[idx] = cnt3[idx] + AddUtil.parseInt((String)ht.get("DLY_CNT"));
							amt1[idx] = amt1[idx] + AddUtil.parseLong((String)ht.get("MON_AMT"));
							amt2[idx] = amt2[idx] + AddUtil.parseLong((String)ht.get("DAY_AMT"));
							amt3[idx] = amt3[idx] + AddUtil.parseLong((String)ht.get("DLY_AMT"));
							cnt5[idx] = cnt5[idx] + AddUtil.parseInt((String)ht.get("MON_CNT2"));
							amt5[idx] = amt5[idx] + AddUtil.parseLong((String)ht.get("MON_AMT2"));				
							
						}
					}
				}
				idx = 1;
				if(vt.size()>0){
					for(int i=0; i<vt.size(); i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						if(String.valueOf(ht.get("GUBUN_NM")).equals("�뿩��")){
							
							if(String.valueOf(ht.get("GUBUN_ST")).equals("�̼���")) idx = 2;
								
							cnt1[idx] = AddUtil.parseInt((String)ht.get("MON_CNT"));
							cnt2[idx] = AddUtil.parseInt((String)ht.get("DAY_CNT"));
							cnt3[idx] = AddUtil.parseInt((String)ht.get("DLY_CNT"));
							amt1[idx] = AddUtil.parseLong((String)ht.get("MON_AMT"));
							amt2[idx] = AddUtil.parseLong((String)ht.get("DAY_AMT"));
							amt3[idx] = AddUtil.parseLong((String)ht.get("DLY_AMT"));
							amt4[idx] = AddUtil.parseLong((String)ht.get("EST_AMT"));				
							cnt5[idx] = AddUtil.parseInt((String)ht.get("MON_CNT2"));
							amt5[idx] = AddUtil.parseLong((String)ht.get("MON_AMT2"));				
				
						}
					}
				}
				%>	

                <tr> 
                    <td colspan="3" align="center" class='title'>��ȹ</td>
                    <td align="right"><%=cnt1[0]+cnt5[0]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt1[0]+amt5[0])%></td>
                    <td align="right"><%=cnt2[0]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[0])%></td>
                    <td align="right"><%=cnt3[0]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt3[0])%></td>
                    <td align="right"><%=cnt2[0]+cnt3[0]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[0]+amt3[0])%></td>
                </tr>		
                <tr> 
                    <td width="3%" rowspan="4" align="center" class='title'>û��</td>
                    <td width="3%" rowspan="3" align="center" class='title'>����</td>
                    <td width="10%" align="center" class='title'>����</td>
                    <td align="right"><%=cnt1[1]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt1[1])%></td>
                    <td align="right"><%=cnt2[1]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[1])%></td>
                    <td align="right"><%=cnt3[1]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt3[1])%></td>
                    <td align="right"><%=cnt2[1]+cnt3[1]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[1]+amt3[1])%></td>
                </tr>		
                <tr> 
                    <td align="center" class='title'>�̼���</td>
                    <td align="right"><%=cnt1[2]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt1[2])%></td>
                    <td align="right"><%=cnt2[2]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[2])%></td>
                    <td align="right"><%=cnt3[2]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt3[2])%></td>
                    <td align="right"><%=cnt2[2]+cnt3[2]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[2]+amt3[2])%></td>
                </tr>		                
                <tr> 
                    <td align="center" class='title'>������(%)</td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt1[1]))/AddUtil.parseFloat(String.valueOf(cnt1[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(amt1[1]))/AddUtil.parseFloat(String.valueOf(amt1[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt2[1]))/AddUtil.parseFloat(String.valueOf(cnt2[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(amt2[1]))/AddUtil.parseFloat(String.valueOf(amt2[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt3[1]))/AddUtil.parseFloat(String.valueOf(cnt3[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(amt3[1]))/AddUtil.parseFloat(String.valueOf(amt3[0]))*100,2)%></td>
                    <td align="right">-</td>
                    <td align="right">-</td>
                </tr>			
                <tr> 
                    <td colspan="2" align="center" class='title'>����</td>
                    <td align="right"><%=cnt5[2]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt5[2])%></td>
                    <td colspan="4" class='title'>&nbsp;</td>
                    <td align="right">-</td>
                    <td align="right">-</td>
                </tr>		
                <tr> 
                    <td colspan="3" align="center" class='title'>��ȹ��������</td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt1[1]))/AddUtil.parseFloat(String.valueOf(cnt1[0]+cnt5[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(amt1[1]))/AddUtil.parseFloat(String.valueOf(amt1[0]+amt5[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt2[1]))/AddUtil.parseFloat(String.valueOf(cnt2[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(amt2[1]))/AddUtil.parseFloat(String.valueOf(amt2[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt3[1]))/AddUtil.parseFloat(String.valueOf(cnt3[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(amt3[1]))/AddUtil.parseFloat(String.valueOf(amt3[0]))*100,2)%></td>
                    <td align="right">-</td>
                    <td align="right">-</td>
                </tr>						 				
                <tr> 
                    <td colspan="3" align="center" class='title'>�����뿩�� �Ѱ�</td>
                    <td align="right" colspan="2"><b><%=AddUtil.parseDecimalLong(amt4[2])%></b></td>
                    <td align="center" class='title'>��ü�뿩��</td>
                    <td align="right" colspan="2"><b><font color=red><%=AddUtil.parseDecimalLong(amt3[2])%></font></b></td>
                    <td align="center" class='title'>��ü��</td>
					<td align="right" colspan="2"><b><font color=red><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(amt3[2]))/AddUtil.parseFloat(String.valueOf(amt4[2]))*100,2)%></font></b></td>
                </tr>																	  		
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ ��Ȳ</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td colspan="2" width="16%"  rowspan="2" class='title'>����</td>
                    <td colspan="2" width="21%"  class='title'>���</td>
                    <td colspan="2" width="21%"  class='title'>����</td>
                    <td colspan="2" width="21%"  class='title'>��ü</td>
                    <td colspan="2" width="21%"  class='title'>�հ�(����+��ü)</td>
                </tr>
                <tr align="center"> 
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                </tr>
          		<%	cnt1[3] = 0;
					cnt2[3] = 0;
					cnt3[3] = 0;
					amt1[3] = 0;
					amt2[3] = 0;
					amt3[3] = 0;
					idx = 0;
					for(int j=0; j<4; j++){
						cnt1[idx] = 0;
						cnt2[idx] = 0;
						cnt3[idx] = 0;
						amt1[idx] = 0;
						amt2[idx] = 0;
						amt3[idx] = 0;
						if(vt.size()>0){
							for(int i=0; i<vt.size(); i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);
								if(String.valueOf(ht.get("GUBUN_NM")).equals(grt_nm[j])){
									cnt1[idx] = cnt1[idx] + AddUtil.parseInt((String)ht.get("MON_CNT"));
									cnt2[idx] = cnt2[idx] + AddUtil.parseInt((String)ht.get("DAY_CNT"));
									cnt3[idx] = cnt3[idx] + AddUtil.parseInt((String)ht.get("DLY_CNT"));
									amt1[idx] = amt1[idx] + AddUtil.parseLong((String)ht.get("MON_AMT"));
									amt2[idx] = amt2[idx] + AddUtil.parseLong((String)ht.get("DAY_AMT"));
									amt3[idx] = amt3[idx] + AddUtil.parseLong((String)ht.get("DLY_AMT"));
								}
							}
						}
						
						cnt1[3] = cnt1[3] + cnt1[idx];
						cnt2[3] = cnt2[3] + cnt2[idx];
						cnt3[3] = cnt3[3] + cnt3[idx];
						amt1[3] = amt1[3] + amt1[idx];
						amt2[3] = amt2[3] + amt2[idx];
						amt3[3] = amt3[3] + amt3[idx];
				%>
                <tr> 
                    <%if(j==0){%>
					<td align="center" class='title' rowspan="4">��ȹ</td>
					<%}%>
                    <td align="center" class='title'><%=grt_nm[j]%></td>					
                    <td align="right"><%=cnt1[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt1[idx])%></td>
                    <td align="right"><%=cnt2[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[idx])%></td>
                    <td align="right"><%=cnt3[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt3[idx])%></td>
                    <td align="right"><%=cnt2[idx]+cnt3[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[idx]+amt3[idx])%></td>
                </tr>			
				<%	}%>	
				<%	idx = 3;%>
                <tr> 
					<td align="center" class='title' colspan="2">�Ұ�</td>
                    <td align="right" class=is><%=cnt1[idx]%></td>
                    <td align="right" class=is><%=AddUtil.parseDecimalLong(amt1[idx])%></td>
                    <td align="right" class=is><%=cnt2[idx]%></td>
                    <td align="right" class=is><%=AddUtil.parseDecimalLong(amt2[idx])%></td>
                    <td align="right" class=is><%=cnt3[idx]%></td>
                    <td align="right" class=is><%=AddUtil.parseDecimalLong(amt3[idx])%></td>
                    <td align="right" class=is><%=cnt2[idx]+cnt3[idx]%></td>
                    <td align="right" class=is><%=AddUtil.parseDecimalLong(amt2[idx]+amt3[idx])%></td>
                </tr>									
          		<%	cnt1[4] = 0;
					cnt2[4] = 0;
					cnt3[4] = 0;
					amt1[4] = 0;
					amt2[4] = 0;
					amt3[4] = 0;
					idx = 1;
					for(int j=0; j<4; j++){
						cnt1[idx] = 0;
						cnt2[idx] = 0;
						cnt3[idx] = 0;
						amt1[idx] = 0;
						amt2[idx] = 0;
						amt3[idx] = 0;
						if(vt.size()>0){
							for(int i=0; i<vt.size(); i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);
								if(String.valueOf(ht.get("GUBUN_NM")).equals(grt_nm[j]) && String.valueOf(ht.get("GUBUN_ST")).equals("����")){
									cnt1[idx] = AddUtil.parseInt((String)ht.get("MON_CNT"));
									cnt2[idx] = AddUtil.parseInt((String)ht.get("DAY_CNT"));
									cnt3[idx] = AddUtil.parseInt((String)ht.get("DLY_CNT"));
									amt1[idx] = AddUtil.parseLong((String)ht.get("MON_AMT"));
									amt2[idx] = AddUtil.parseLong((String)ht.get("DAY_AMT"));
									amt3[idx] = AddUtil.parseLong((String)ht.get("DLY_AMT"));
								}
							}
						}
						
						cnt1[4] = cnt1[4] + cnt1[idx];
						cnt2[4] = cnt2[4] + cnt2[idx];
						cnt3[4] = cnt3[4] + cnt3[idx];
						amt1[4] = amt1[4] + amt1[idx];
						amt2[4] = amt2[4] + amt2[idx];
						amt3[4] = amt3[4] + amt3[idx];
				%>
                <tr> 
                    <%if(j==0){%>
					<td align="center" class='title' rowspan="4">����</td>
					<%}%>
                    <td align="center" class='title'><%=grt_nm[j]%></td>					
                    <td align="right"><%=cnt1[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt1[idx])%></td>
                    <td align="right"><%=cnt2[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[idx])%></td>
                    <td align="right"><%=cnt3[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt3[idx])%></td>
                    <td align="right"><%=cnt2[idx]+cnt3[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[idx]+amt3[idx])%></td>
                </tr>			
				<%	}%>			
				<%	idx = 4;%>
                <tr> 
					<td align="center" class='title' colspan="2">�Ұ�</td>
                    <td align="right" class=is><%=cnt1[idx]%></td>
                    <td align="right" class=is><%=AddUtil.parseDecimalLong(amt1[idx])%></td>
                    <td align="right" class=is><%=cnt2[idx]%></td>
                    <td align="right" class=is><%=AddUtil.parseDecimalLong(amt2[idx])%></td>
                    <td align="right" class=is><%=cnt3[idx]%></td>
                    <td align="right" class=is><%=AddUtil.parseDecimalLong(amt3[idx])%></td>
                    <td align="right" class=is><%=cnt2[idx]+cnt3[idx]%></td>
                    <td align="right" class=is><%=AddUtil.parseDecimalLong(amt2[idx]+amt3[idx])%></td>
                </tr>													
          		<%		cnt1[5] = 0;
					cnt2[5] = 0;
					cnt3[5] = 0;
					amt1[5] = 0;
					amt2[5] = 0;
					amt3[5] = 0;
					idx = 2;
					for(int j=0; j<4; j++){
						cnt1[idx] = 0;
						cnt2[idx] = 0;
						cnt3[idx] = 0;
						amt1[idx] = 0;
						amt2[idx] = 0;
						amt3[idx] = 0;
						if(vt.size()>0){
							for(int i=0; i<vt.size(); i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);
								if(String.valueOf(ht.get("GUBUN_NM")).equals(grt_nm[j]) && String.valueOf(ht.get("GUBUN_ST")).equals("�̼���")){
									cnt1[idx] = AddUtil.parseInt((String)ht.get("MON_CNT"));
									cnt2[idx] = AddUtil.parseInt((String)ht.get("DAY_CNT"));
									cnt3[idx] = AddUtil.parseInt((String)ht.get("DLY_CNT"));
									amt1[idx] = AddUtil.parseLong((String)ht.get("MON_AMT"));
									amt2[idx] = AddUtil.parseLong((String)ht.get("DAY_AMT"));
									amt3[idx] = AddUtil.parseLong((String)ht.get("DLY_AMT"));
								}
							}
						}
						cnt1[5] = cnt1[5] + cnt1[idx];
						cnt2[5] = cnt2[5] + cnt2[idx];
						cnt3[5] = cnt3[5] + cnt3[idx];
						amt1[5] = amt1[5] + amt1[idx];
						amt2[5] = amt2[5] + amt2[idx];
						amt3[5] = amt3[5] + amt3[idx];
				%>
                <tr> 
                    <%if(j==0){%>
					<td align="center" class='title' rowspan="4">�̼���</td>
					<%}%>
                    <td align="center" class='title'><%=grt_nm[j]%></td>					
                    <td align="right"><%=cnt1[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt1[idx])%></td>
                    <td align="right"><%=cnt2[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[idx])%></td>
                    <td align="right"><%=cnt3[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt3[idx])%></td>
                    <td align="right"><%=cnt2[idx]+cnt3[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[idx]+amt3[idx])%></td>
                </tr>			
				<%	}%>									
				<%	idx = 5;%>
                <tr> 
					<td align="center" class='title' colspan="2">�Ұ�</td>
                    <td align="right" class=is><%=cnt1[idx]%></td>
                    <td align="right" class=is><%=AddUtil.parseDecimalLong(amt1[idx])%></td>
                    <td align="right" class=is><%=cnt2[idx]%></td>
                    <td align="right" class=is><%=AddUtil.parseDecimalLong(amt2[idx])%></td>
                    <td align="right" class=is><%=cnt3[idx]%></td>
                    <td align="right" class=is><%=AddUtil.parseDecimalLong(amt3[idx])%></td>
                    <td align="right" class=is><%=cnt2[idx]+cnt3[idx]%></td>
                    <td align="right" class=is><%=AddUtil.parseDecimalLong(amt2[idx]+amt3[idx])%></td>
                </tr>													
                <tr> 
                    <td align="center" class='title' colspan="2">����(%)</td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt1[4]))/AddUtil.parseFloat(String.valueOf(cnt1[3]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(amt1[4]))/AddUtil.parseFloat(String.valueOf(amt1[3]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt2[4]))/AddUtil.parseFloat(String.valueOf(cnt2[3]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(amt2[4]))/AddUtil.parseFloat(String.valueOf(amt2[3]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt3[4]))/AddUtil.parseFloat(String.valueOf(cnt3[3]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(amt3[4]))/AddUtil.parseFloat(String.valueOf(amt3[3]))*100,2)%></td>
                    <td align="right">-</td>
                    <td align="right">-</td>
                </tr>	
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>����Ʈ/���� �뿩�� ������Ȳ</span></td>
    </tr>    

    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td width="16%" colspan="2" rowspan="2"  class='title'>����</td>
                    <td colspan="2" width="21%"  class='title'>���</td>
                    <td colspan="2" width="21%"  class='title'>����</td>
                    <td colspan="2" width="21%"  class='title'>��ü</td>
                    <td colspan="2" width="21%"  class='title'>�հ�(����+��ü)</td>
                </tr>
                <tr align="center"> 
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                </tr>
		<%for(int j=0; j<3; j++){
			for(int i=0; i<6; i++){
				cnt1[i] = 0;
				cnt2[i] = 0;
				cnt3[i] = 0;
				amt1[i] = 0;
				amt2[i] = 0;
				amt3[i] = 0;
			}%>									
                				
          		<%	idx = 0;
					if(vt.size()>0){
						for(int i=0; i<vt.size(); i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							if(String.valueOf(ht.get("GUBUN_NM")).equals(etc_nm[j])){
								cnt1[idx] = cnt1[idx] + AddUtil.parseInt((String)ht.get("MON_CNT"));
								cnt2[idx] = cnt2[idx] + AddUtil.parseInt((String)ht.get("DAY_CNT"));
								cnt3[idx] = cnt3[idx] + AddUtil.parseInt((String)ht.get("DLY_CNT"));
								amt1[idx] = amt1[idx] + AddUtil.parseLong((String)ht.get("MON_AMT"));
								amt2[idx] = amt2[idx] + AddUtil.parseLong((String)ht.get("DAY_AMT"));
								amt3[idx] = amt3[idx] + AddUtil.parseLong((String)ht.get("DLY_AMT"));
							}
						}
					}
		 		%>
                <tr> 
                    <td width="6%" rowspan="4" align="center" class='title'><%=etc_nm[j]%></td>
                    <td width="10%" align="center" class='title'>��ȹ</td>
                    <td align="right"><%=cnt1[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt1[idx])%></td>
                    <td align="right"><%=cnt2[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[idx])%></td>
                    <td align="right"><%=cnt3[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt3[idx])%></td>
                    <td align="right"><%=cnt2[idx]+cnt3[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[idx]+amt3[idx])%></td>
                </tr>		
          		<%		row1_yn = "";
          				row2_yn = "";
          				idx = 1;
					if(vt.size()>0){
						for(int i=0; i<vt.size(); i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							if(String.valueOf(ht.get("GUBUN_NM")).equals(etc_nm[j])){
								
								if(String.valueOf(ht.get("GUBUN_ST")).equals("����")) 	row1_yn = "Y";
								if(String.valueOf(ht.get("GUBUN_ST")).equals("�̼���")) row2_yn = "Y";

								if(String.valueOf(ht.get("GUBUN_ST")).equals("�̼���")) idx = 2;								
								
								cnt1[idx] = AddUtil.parseInt((String)ht.get("MON_CNT"));
								cnt2[idx] = AddUtil.parseInt((String)ht.get("DAY_CNT"));
								cnt3[idx] = AddUtil.parseInt((String)ht.get("DLY_CNT"));
								amt1[idx] = AddUtil.parseLong((String)ht.get("MON_AMT"));
								amt2[idx] = AddUtil.parseLong((String)ht.get("DAY_AMT"));
								amt3[idx] = AddUtil.parseLong((String)ht.get("DLY_AMT"));
							%>							
                <tr> 
                    <td align="center" class='title'><%=ht.get("GUBUN_ST")%></td>
                    <td align="right"><%=cnt1[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt1[idx])%></td>
                    <td align="right"><%=cnt2[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[idx])%></td>
                    <td align="right"><%=cnt3[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt3[idx])%></td>
                    <td align="right"><%=cnt2[idx]+cnt3[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[idx]+amt3[idx])%></td>
                </tr>		
				<%			}
						}
					}%>	
		<%if(amt1[1]+amt2[1]+amt3[1] == 0 && row1_yn.equals("")){%>			
                <tr> 
                    <td align="center" class='title'>����</td>
                    <td align="right"><%=cnt1[1]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt1[1])%></td>
                    <td align="right"><%=cnt2[1]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[1])%></td>
                    <td align="right"><%=cnt3[1]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt3[1])%></td>
                    <td align="right"><%=cnt2[1]+cnt3[1]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[1]+amt3[1])%></td>
                </tr>			
		<%}%>
		<%if(amt1[2]+amt2[2]+amt3[2] == 0 && row2_yn.equals("")){%>			
                <tr> 
                    <td align="center" class='title'>�̼���</td>
                    <td align="right"><%=cnt1[2]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt1[2])%></td>
                    <td align="right"><%=cnt2[2]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[2])%></td>
                    <td align="right"><%=cnt3[2]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt3[2])%></td>
                    <td align="right"><%=cnt2[2]+cnt3[2]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[2]+amt3[2])%></td>
                </tr>			
		<%}%>		
                <tr> 
                    <td align="center" class='title'>����(%)</td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt1[1]))/AddUtil.parseFloat(String.valueOf(cnt1[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(amt1[1]))/AddUtil.parseFloat(String.valueOf(amt1[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt2[1]))/AddUtil.parseFloat(String.valueOf(cnt2[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(amt2[1]))/AddUtil.parseFloat(String.valueOf(amt2[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt3[1]))/AddUtil.parseFloat(String.valueOf(cnt3[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(amt3[1]))/AddUtil.parseFloat(String.valueOf(amt3[0]))*100,2)%></td>
                    <td align="right">-</td>
                    <td align="right">-</td>
                </tr>			
		<%}%>	
            </table>
        </td>
    </tr>				
	
    
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��Ÿ������Ȳ</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td width="16%" colspan="2" rowspan="2"  class='title'>����</td>
                    <td colspan="2" width="21%"  class='title'>���</td>
                    <td colspan="2" width="21%"  class='title'>����</td>
                    <td colspan="2" width="21%"  class='title'>��ü</td>
                    <td colspan="2" width="21%"  class='title'>�հ�(����+��ü)</td>
                </tr>
                <tr align="center"> 
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                </tr>		
		<%for(int j=0; j<3; j++){
			for(int i=0; i<6; i++){
				cnt1[i] = 0;
				cnt2[i] = 0;
				cnt3[i] = 0;
				amt1[i] = 0;
				amt2[i] = 0;
				amt3[i] = 0;
			}%>									
                		
          		<%		row1_yn = "";
          				row2_yn = "";
          				idx = 0;
					if(vt.size()>0){
						for(int i=0; i<vt.size(); i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							if(String.valueOf(ht.get("GUBUN_NM")).equals(etc_nm2[j])){
								cnt1[idx] = cnt1[idx] + AddUtil.parseInt((String)ht.get("MON_CNT"));
								cnt2[idx] = cnt2[idx] + AddUtil.parseInt((String)ht.get("DAY_CNT"));
								cnt3[idx] = cnt3[idx] + AddUtil.parseInt((String)ht.get("DLY_CNT"));
								amt1[idx] = amt1[idx] + AddUtil.parseLong((String)ht.get("MON_AMT"));
								amt2[idx] = amt2[idx] + AddUtil.parseLong((String)ht.get("DAY_AMT"));
								amt3[idx] = amt3[idx] + AddUtil.parseLong((String)ht.get("DLY_AMT"));
							}
						}
					}
		 		%>
                <tr> 
                    <td width="6%" rowspan="4" align="center" class='title'><%=etc_nm2[j]%></td>
                    <td width="10%" align="center" class='title'>��ȹ</td>
                    <td align="right"><%=cnt1[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt1[idx])%></td>
                    <td align="right"><%=cnt2[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[idx])%></td>
                    <td align="right"><%=cnt3[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt3[idx])%></td>
                    <td align="right"><%=cnt2[idx]+cnt3[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[idx]+amt3[idx])%></td>
                </tr>		
          		<%	idx = 1;
					if(vt.size()>0){
						for(int i=0; i<vt.size(); i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							if(String.valueOf(ht.get("GUBUN_NM")).equals(etc_nm2[j])){
								
								if(String.valueOf(ht.get("GUBUN_ST")).equals("����")) 	row1_yn = "Y";
								if(String.valueOf(ht.get("GUBUN_ST")).equals("�̼���")) row2_yn = "Y";
								
								if(String.valueOf(ht.get("GUBUN_ST")).equals("�̼���")) idx = 2;
								
								cnt1[idx] = AddUtil.parseInt((String)ht.get("MON_CNT"));
								cnt2[idx] = AddUtil.parseInt((String)ht.get("DAY_CNT"));
								cnt3[idx] = AddUtil.parseInt((String)ht.get("DLY_CNT"));
								amt1[idx] = AddUtil.parseLong((String)ht.get("MON_AMT"));
								amt2[idx] = AddUtil.parseLong((String)ht.get("DAY_AMT"));
								amt3[idx] = AddUtil.parseLong((String)ht.get("DLY_AMT"));
							%>
                <tr> 
                    <td align="center" class='title'><%=ht.get("GUBUN_ST")%></td>
                    <td align="right"><%=cnt1[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt1[idx])%></td>
                    <td align="right"><%=cnt2[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[idx])%></td>
                    <td align="right"><%=cnt3[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt3[idx])%></td>
                    <td align="right"><%=cnt2[idx]+cnt3[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[idx]+amt3[idx])%></td>
                </tr>		
				<%			}
						}
					}%>	
		<%if(amt1[1]+amt2[1]+amt3[1] == 0 && row1_yn.equals("")){%>			
                <tr> 
                    <td align="center" class='title'>����</td>
                    <td align="right"><%=cnt1[1]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt1[1])%></td>
                    <td align="right"><%=cnt2[1]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[1])%></td>
                    <td align="right"><%=cnt3[1]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt3[1])%></td>
                    <td align="right"><%=cnt2[1]+cnt3[1]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[1]+amt3[1])%></td>
                </tr>			
		<%}%>
		<%if(amt1[2]+amt2[2]+amt3[2] == 0 && row2_yn.equals("")){%>			
                <tr> 
                    <td align="center" class='title'>�̼���</td>
                    <td align="right"><%=cnt1[2]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt1[2])%></td>
                    <td align="right"><%=cnt2[2]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[2])%></td>
                    <td align="right"><%=cnt3[2]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt3[2])%></td>
                    <td align="right"><%=cnt2[2]+cnt3[2]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[2]+amt3[2])%></td>
                </tr>			
		<%}%>					
                <tr> 
                    <td align="center" class='title'>����(%)</td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt1[1]))/AddUtil.parseFloat(String.valueOf(cnt1[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(amt1[1]))/AddUtil.parseFloat(String.valueOf(amt1[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt2[1]))/AddUtil.parseFloat(String.valueOf(cnt2[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(amt2[1]))/AddUtil.parseFloat(String.valueOf(amt2[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt3[1]))/AddUtil.parseFloat(String.valueOf(cnt3[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(amt3[1]))/AddUtil.parseFloat(String.valueOf(amt3[0]))*100,2)%></td>
                    <td align="right">-</td>
                    <td align="right">-</td>
                </tr>			
		<%}%>	
            </table>
        </td>
    </tr>				
		
    <tr> 
        <td class=h></td>
    </tr>	
    <tr> 
        <td align="right"> 
        <%if(auth_rw.equals("6")){%>
        <!--
        <a href="javascript:save();"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>
        -->
        <%}%>
        </td>
    </tr>
    <tr> 
        <td><iframe src="/acar/admin/stat_end_incom_pay_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>&from_page=/acar/account/incoming_magam.jsp" name="i_list" width="100%" height="45" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>									
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
