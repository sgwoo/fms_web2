<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.consignment.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�Ⱓ���
	function view_precost(cost_ym, cost_st, car_use){
//		window.open('view_precost_ins_list.jsp?cost_ym='+cost_ym+'&cost_st='+cost_st+'&car_use='+car_use, "PRECOST_LIST", "left=0, top=0, width=800, height=768, scrollbars=yes, status=yes, resize");
	}
	//���轺����
	function view_ins_scd(cost_ym, pay_yn){
		window.open('view_ins_scd_list.jsp?cost_ym='+cost_ym+'&pay_yn='+pay_yn, "INS_SCD_LIST", "left=0, top=0, width=850, height=768, scrollbars=yes, status=yes, resize");		
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	//��ü�� Ź����Ȳ
	Vector scds1 = cs_db.getConsOffStat(gubun1);
	int scd_size1 = scds1.size();
	
	//�����Һ� Ź����Ȳ
	Vector scds2 = cs_db.getConsBrStat(gubun1);
	int scd_size2 = scds2.size();
	
	//����� Ź�ۿ�û ��Ȳ
	Vector scds3 = cs_db.getConsUserStat(gubun1);
	int scd_size3 = scds3.size();
	
	int sum[]	 	= new int[22];
	
	int sum0 = 0;
	int sum1 = 0;
	int sum2 = 0;
	int sum3 = 0;
	int sum4 = 0;
	int sum5 = 0;
	int sum6 = 0;
	int sum7 = 0;
	int sum8 = 0;
	int sum9 = 0;
	int sum10 = 0;
	int sum11 = 0;
	int sum12 = 0;
	int sum13 = 0;
	int sum14 = 0;
	int sum15 = 0;
	int sum16 = 0;
	int sum17 = 0;
	int sum18 = 0;
	int sum19 = 0;
	int sum20 = 0;
	int sum21 = 0;
	int sum22 = 0;
	
%>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun0' value='<%=gubun0%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='gubun7' value='<%=gubun7%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='ins_st' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='car_comp_id' value=''>
<input type='hidden' name='tot_su' value=''>
<input type='hidden' name='go_url' value='../ins_stat/ins_s4_frame.jsp'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>Ź�۾�ü�� ������Ȳ</span></td>
    </tr>
    <tr>
		<td class=line2 ></td>
	</tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='5%' rowspan="3" class='title'>���</td>
            <td colspan="2" rowspan="2" class='title'>�հ�</td>
            <td colspan="20" class='title'>Ź�۾�ü</td>            
          </tr>
          <tr>
            <td colspan="2" class='title'>��üŹ��</td>
            <td colspan="2" class='title'>����</td>
            <td colspan="2" class='title'>����Ư��</td>
            <td colspan="2" class='title'>��������/�������</td>
            <td colspan="2" class='title'>����ī��(����)</td>
            <td colspan="2" class='title'>����ī��(�λ�)</td>
            <!-- <td colspan="2" class='title'>�ϵ�����(�λ�)</td>
            <td colspan="2" class='title'>�ϵ�����(����)</td>
            <td colspan="2" class='title'>�ϵ�����(�뱸)</td> -->
            <td colspan="2" class='title'>������Ƽ(�λ�)</td>
            <td colspan="2" class='title'>������Ƽ(����)</td>
            <td colspan="2" class='title'>������Ƽ(�뱸)</td>
            <td colspan="2" class='title'>�۽�Ʈ����̺�(����)</td>
          </tr>
          <tr>
            <td class='title' width="3%">�Ǽ�</td>
            <td class='title' width="6%">�ݾ�</td>
            <td class='title' width="3%">�Ǽ�</td>
            <td class='title' width="6%">�ݾ�</td>
            <td class='title' width="3%">�Ǽ�</td>
            <td class='title' width="6%">�ݾ�</td>
            <td class='title' width="3%">�Ǽ�</td>
            <td class='title' width="6%">�ݾ�</td>
            <td class='title' width="3%">�Ǽ�</td>
            <td class='title' width="6%">�ݾ�</td>
            <td class='title' width="3%">�Ǽ�</td>
            <td class='title' width="6%">�ݾ�</td>
            <td class='title' width="3%">�Ǽ�</td>
            <td class='title' width="6%">�ݾ�</td>
            <td class='title' width="3%">�Ǽ�</td>
            <td class='title' width="6%">�ݾ�</td>
            <td class='title' width="3%">�Ǽ�</td>
            <td class='title' width="5%">�ݾ�</td>
            <td class='title' width="3%">�Ǽ�</td>
            <td class='title' width="5%">�ݾ�</td>
            <td class='title' width="3%">�Ǽ�</td>
            <td class='title' width="5%">�ݾ�</td>
          </tr>
          <%	for(int i = 0 ; i < scd_size1 ; i++){
					Hashtable ht = (Hashtable)scds1.elementAt(i);%>		  
          <tr> 
            <td align="center"><%=ht.get("YM")%></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT0")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT0")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT1")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT1")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT2")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT2")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT3")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT3")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT4")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT4")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT5")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT5")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT6")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT6")))%>��</td>            
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT7")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT7")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT8")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT8")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT9")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT9")))%>��</td>    
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT10")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT10")))%>��</td>        
          </tr>
<%			
			sum[0]  = sum[0]  + Util.parseInt(String.valueOf(ht.get("CNT0")));
			sum[1]  = sum[1]  + Util.parseInt(String.valueOf(ht.get("AMT0")));
			sum[2]  = sum[2]  + Util.parseInt(String.valueOf(ht.get("CNT1")));
			sum[3]  = sum[3]  + Util.parseInt(String.valueOf(ht.get("AMT1")));
			sum[4]  = sum[4]  + Util.parseInt(String.valueOf(ht.get("CNT2")));			
			sum[5]  = sum[5]  + Util.parseInt(String.valueOf(ht.get("AMT2")));
			sum[6]  = sum[6]  + Util.parseInt(String.valueOf(ht.get("CNT3")));
			sum[7]  = sum[7]  + Util.parseInt(String.valueOf(ht.get("AMT3")));
			sum[8]  = sum[8]  + Util.parseInt(String.valueOf(ht.get("CNT4")));
			sum[9]  = sum[9]  + Util.parseInt(String.valueOf(ht.get("AMT4")));			
			sum[10] = sum[10] + Util.parseInt(String.valueOf(ht.get("CNT5")));
			sum[11] = sum[11] + Util.parseInt(String.valueOf(ht.get("AMT5")));
			sum[12] = sum[12] + Util.parseInt(String.valueOf(ht.get("CNT6")));
			sum[13] = sum[13] + Util.parseInt(String.valueOf(ht.get("AMT6")));
			sum[14] = sum[14] + Util.parseInt(String.valueOf(ht.get("CNT7")));
			sum[15] = sum[15] + Util.parseInt(String.valueOf(ht.get("AMT7")));
			sum[16] = sum[16] + Util.parseInt(String.valueOf(ht.get("CNT8")));			
			sum[17] = sum[17] + Util.parseInt(String.valueOf(ht.get("AMT8")));
			sum[18] = sum[18] + Util.parseInt(String.valueOf(ht.get("CNT9")));
			sum[19] = sum[19] + Util.parseInt(String.valueOf(ht.get("AMT9")));
			sum[20] = sum[20] + Util.parseInt(String.valueOf(ht.get("CNT10")));
			sum[21] = sum[21] + Util.parseInt(String.valueOf(ht.get("AMT10")));
}%>			  
          <tr> 
            <td align="center" class=title>�հ�</td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[0])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[1])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[2])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[3])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[4])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[5])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[6])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[7])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[8])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[9])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[10])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[11])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[12])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[13])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[14])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[15])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[16])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[17])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[18])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[19])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[20])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[21])%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
		<%	for(int k = 0 ; k < 22 ; k++){
                		//�Ұ� �ʱ�ȭ
                		sum[k] = 0;                		
                	}	                		
		%>    	
    <tr> 
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����Һ� ������Ȳ</span></td>
    </tr>
    <tr>
		<td class=line2 ></td>
	</tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='5%' rowspan="3" class='title'>���</td>
            <td colspan="2" rowspan="2" class='title'>�հ�</td>
            <td colspan="16" class='title'>������</td>            
          </tr>
          <tr>
            <td colspan="2" class='title'>����</td>
            <td colspan="2" class='title'>��������</td>
            <td colspan="2" class='title'>��������</td>
            <td colspan="2" class='title'>�뱸����</td>
            <td colspan="2" class='title'>��������</td>
            <td colspan="2" class='title'>�λ�����</td>
            <td colspan="2" class='title'>��������</td>
            <td colspan="2" class='title'>��õ����</td>            
          </tr>
          <tr>
            <td class='title' width="5%">�Ǽ�</td>
            <td class='title' width="10%">�ݾ�</td>
            <td class='title' width="3%">�Ǽ�</td>
            <td class='title' width="7%">�ݾ�</td>
            <td class='title' width="3%">�Ǽ�</td>
            <td class='title' width="7%">�ݾ�</td>
            <td class='title' width="3%">�Ǽ�</td>
            <td class='title' width="7%">�ݾ�</td>
            <td class='title' width="3%">�Ǽ�</td>
            <td class='title' width="7%">�ݾ�</td>
            <td class='title' width="3%">�Ǽ�</td>
            <td class='title' width="7%">�ݾ�</td>
            <td class='title' width="3%">�Ǽ�</td>
            <td class='title' width="7%">�ݾ�</td>
            <td class='title' width="3%">�Ǽ�</td>
            <td class='title' width="7%">�ݾ�</td>
            <td class='title' width="3%">�Ǽ�</td>
            <td class='title' width="7%">�ݾ�</td>
          </tr>
          <%	for(int i = 0 ; i < scd_size2 ; i++){
					Hashtable ht = (Hashtable)scds2.elementAt(i);%>		  
          <tr> 
            <td align="center"><%=ht.get("YM")%></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT0")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT0")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT1")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT1")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT2")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT2")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT3")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT3")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT4")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT4")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT5")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT5")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT6")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT6")))%>��</td>            
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT7")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT7")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT8")))%>��</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT8")))%>��</td>
          </tr>
<%			
			sum[0]  = sum[0]  + Util.parseInt(String.valueOf(ht.get("CNT0")));
			sum[1]  = sum[1]  + Util.parseInt(String.valueOf(ht.get("AMT0")));
			sum[2]  = sum[2]  + Util.parseInt(String.valueOf(ht.get("CNT1")));
			sum[3]  = sum[3]  + Util.parseInt(String.valueOf(ht.get("AMT1")));
			sum[4]  = sum[4]  + Util.parseInt(String.valueOf(ht.get("CNT2")));			
			sum[5]  = sum[5]  + Util.parseInt(String.valueOf(ht.get("AMT2")));
			sum[6]  = sum[6]  + Util.parseInt(String.valueOf(ht.get("CNT3")));
			sum[7]  = sum[7]  + Util.parseInt(String.valueOf(ht.get("AMT3")));
			sum[8]  = sum[8]  + Util.parseInt(String.valueOf(ht.get("CNT4")));
			sum[9]  = sum[9]  + Util.parseInt(String.valueOf(ht.get("AMT4")));			
			sum[10] = sum[10] + Util.parseInt(String.valueOf(ht.get("CNT5")));
			sum[11] = sum[11] + Util.parseInt(String.valueOf(ht.get("AMT5")));
			sum[12] = sum[12] + Util.parseInt(String.valueOf(ht.get("CNT6")));
			sum[13] = sum[13] + Util.parseInt(String.valueOf(ht.get("AMT6")));
			sum[14] = sum[14] + Util.parseInt(String.valueOf(ht.get("CNT7")));
			sum[15] = sum[15] + Util.parseInt(String.valueOf(ht.get("AMT7")));
			sum[16] = sum[16] + Util.parseInt(String.valueOf(ht.get("CNT8")));			
			sum[17] = sum[17] + Util.parseInt(String.valueOf(ht.get("AMT8")));
}%>			  
          <tr> 
            <td align="center" class=title>�հ�</td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[0])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[1])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[2])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[3])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[4])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[5])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[6])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[7])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[8])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[9])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[10])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[11])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[12])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[13])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[14])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[15])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[16])%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum[17])%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
		<%	for(int k = 0 ; k < 20 ; k++){
                		//�Ұ� �ʱ�ȭ
                		sum[k] = 0;                		
                	}	                		
		%>    
    <tr> 
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����� ������Ȳ</span></td>
    </tr>
    <tr>
		<td class=line2 ></td>
	</tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width="4%" class='title'>����</td>
            <td width="10%" class='title'>�μ�</td>
            <td width="8%" class='title'>����</td>
            <td width="6%" class='title'>�հ�</td>
            <td class='title' width="6%">1��</td>
            <td class='title' width="6%">2��</td>
            <td class='title' width="6%">3��</td>
            <td class='title' width="6%">4��</td>
            <td class='title' width="6%">5��</td>
            <td class='title' width="6%">6��</td>
            <td class='title' width="6%">7��</td>
            <td class='title' width="6%">8��</td>
            <td class='title' width="6%">9��</td>
            <td class='title' width="6%">10��</td>
            <td class='title' width="6%">11��</td>
            <td class='title' width="6%">12��</td>
          </tr>
          <%	for(int i = 0 ; i < scd_size3 ; i++){
					Hashtable ht = (Hashtable)scds3.elementAt(i);%>		  
          <tr> 
            <td align="center"><%=i+1%></td>
            <td align="center"><%=ht.get("NM")%></td>
            <td align="center"><%=ht.get("USER_NM")%></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT0")))%>��&nbsp;&nbsp;</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT1")))%>��&nbsp;&nbsp;</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT2")))%>��&nbsp;</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT3")))%>��&nbsp;</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT4")))%>��&nbsp;</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT5")))%>��&nbsp;</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT6")))%>��&nbsp;</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT7")))%>��&nbsp;</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT8")))%>��&nbsp;</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT9")))%>��&nbsp;</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT10")))%>��&nbsp;</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT11")))%>��&nbsp;</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT12")))%>��&nbsp;</td>
          </tr>
<%			sum0 = sum0 + Util.parseInt(String.valueOf(ht.get("CNT0")));
			sum1 = sum1 + Util.parseInt(String.valueOf(ht.get("CNT1")));
			sum2 = sum2 + Util.parseInt(String.valueOf(ht.get("CNT2")));
			sum3 = sum3 + Util.parseInt(String.valueOf(ht.get("CNT3")));
			sum4 = sum4 + Util.parseInt(String.valueOf(ht.get("CNT4")));
			sum5 = sum5 + Util.parseInt(String.valueOf(ht.get("CNT5")));
			
			sum6 = sum6 + Util.parseInt(String.valueOf(ht.get("CNT6")));
			sum7 = sum7 + Util.parseInt(String.valueOf(ht.get("CNT7")));
			sum8 = sum8 + Util.parseInt(String.valueOf(ht.get("CNT8")));
			sum9 = sum9 + Util.parseInt(String.valueOf(ht.get("CNT9")));
			sum10 = sum10 + Util.parseInt(String.valueOf(ht.get("CNT10")));
			sum11 = sum11 + Util.parseInt(String.valueOf(ht.get("CNT11")));
			sum12 = sum12 + Util.parseInt(String.valueOf(ht.get("CNT12")));
}%>			  
          <tr> 
            <td colspan="3" align="center" class=title>��</td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum0)%>��&nbsp;</td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum1)%>��&nbsp;</td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum2)%>��&nbsp;</td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum3)%>��&nbsp;</td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum4)%>��&nbsp;</td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum5)%>��&nbsp;</td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum6)%>��&nbsp;</td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum7)%>��&nbsp;&nbsp;</td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum8)%>��&nbsp;</td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum9)%>��&nbsp;</td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum10)%>��&nbsp;</td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum11)%>��&nbsp;</td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(sum12)%>��&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>	
  </table>
</form>
</body>
</html>
