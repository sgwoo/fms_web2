<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.alink.*, acar.car_sche.*"%>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	
	ALinkDatabase alk_db = ALinkDatabase.getInstance();
	
	Vector vt = new Vector();

	long t_cnt1 = 0;
	long t_cnt2 = 0;
	long t_cnt3 = 0;
	long t_cnt4 = 0;
	long tot = 0;
	long tot2 = 0;
	
	vt = alk_db.Moncount(st_year, st_mon);
	int vt_size = vt.size();
	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		t_cnt1 +=  AddUtil.parseLong(String.valueOf(ht.get("AC611")));			
		t_cnt2 +=  AddUtil.parseLong(String.valueOf(ht.get("AC111")));
		t_cnt3 +=  AddUtil.parseLong(String.valueOf(ht.get("AC711")));
		t_cnt4 +=  AddUtil.parseLong(String.valueOf(ht.get("AC811")));
		tot   += AddUtil.parseLong(String.valueOf(ht.get("ACTOT")));
		tot2 += AddUtil.parseLong(String.valueOf(ht.get("ACTOT2")));
	}

	//�߰� ����VV(2017.11.06)
	long t_cnt1_over = t_cnt1 - 100;
	long t_cnt2_over = t_cnt2 - 900;
	long t_cnt3_over = t_cnt3 - 500;
	long t_cnt4_over = t_cnt4;
	long papylCnt = 0;
	
	Vector vt2 = new Vector();
	vt2 = alk_db.MoncountPapyl(st_year, st_mon);
	int vt2_size = vt2.size();
	for(int i = 0 ; i < vt2_size ; i++){
		Hashtable ht2 = (Hashtable)vt2.elementAt(i);
		papylCnt +=  AddUtil.parseLong(String.valueOf(ht2.get("PAPYLCNT")));
	}
	long papylCnt_over = papylCnt - 1000;
	if(papylCnt_over < 0){	papylCnt_over = 0;	}
	if(t_cnt3_over < 0){		t_cnt3_over = 0;		}
	
	//���� ���ǿ� ���� ���� ������ �� ��������
	boolean papyl_fm = false;	//���Ǹ���(���뿩)
	boolean acta1_fm = false;	//��Ÿ����Ʈ(����Ʈ+�ε��μ���)
	boolean acta2_fm = false;	//��Ÿ����Ʈ(���뿩)
	if(papylCnt > 0){				papyl_fm = true;		}
	if((t_cnt1+t_cnt2) > 0){	acta1_fm = true;		}
	if(t_cnt3 > 0){					acta2_fm = true;		}
	
	//��Ÿ����Ʈ ���ڰ�༭ ��౸�к� ī����(20190712) - �Ϸ��
	Hashtable ht3 = alk_db.getLCRentLinkMCount(st_year, st_mon);
	//��Ÿ����Ʈ ���ڰ�༭ ��౸�к� ī����(20190712) - ��ϰ�
	Hashtable ht4 = alk_db.getLCRentLinkMRCount(st_year, st_mon);

	int h3_cnt_tot = AddUtil.parseInt(String.valueOf(ht3.get("CNT1")))+AddUtil.parseInt(String.valueOf(ht3.get("CNT2")))+AddUtil.parseInt(String.valueOf(ht3.get("CNT3")));
	
	if(t_cnt3 > h3_cnt_tot){
		if(ck_acar_id.equals("000029")){
			out.println("���뿩 ���γ��� �հ谡���� �ǻ�뷮�� ũ��. �ǻ�뷮 "+t_cnt3+"��");
		}
		t_cnt3 = h3_cnt_tot;
		t_cnt3_over = t_cnt3 - 500;
		if(t_cnt3_over < 0){		t_cnt3_over = 0;		}
	}
%>
<html>
<head><title>FMS</title>
<style type="text/css">
.td_style{	padding-right: 10px;}
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:">

<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>

<!-- ��û���׿� ���� ǥ ���� �ۼ� (2017.11.06)-->
<table border="0" cellspacing="0" cellpadding="0" width=1000>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
	    <td class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<colgroup>
            		<col width="6%">
            		<col width="8%">
            		<col width="8%">
            		<col width="13%">
            		<col width="13%">
            		<col width="13%">
            		<col width="13%">
            		<col width="13%">
            		<col width="13%">            		
            	</colgroup>
				<tbody>
					<tr>
						<td class="title" colspan="3" rowspan="2">����</td>
						<%if(papyl_fm){%><td class="title">(��)���Ǹ���</td><%}%>
						<%-- <%if(acta1_fm){%><td class="title" colspan="3">(��)��Ÿ����Ʈ</td><%}%>
						<%if(acta2_fm){%><td class="title">(��)��Ÿ����Ʈ</td><%}%> --%>
						<%if(acta1_fm){%><td class="title" colspan="4">�����</td><%}%>
						<%if(acta2_fm){%><td class="title">������</td><%}%>
						<td class="title" rowspan="2">�հ�</td>
					</tr>
					<tr>
						<%if(papyl_fm){%><td class="title">��༭(���뿩)</td><%}%>
						<%if(acta1_fm){%><td class="title">��༭(����Ʈ)</td><%}%>
						<%if(acta1_fm){%><td class="title">�ε��μ���</td><%}%>
						<%if(acta1_fm){%><td class="title">��༭(���뿩)</td><%}%>
						<%if(acta1_fm){%><td class="title">�Ұ�</td><%}%>
						<%if(acta2_fm){%><td class="title">��༭(���뿩)</td><%}%>
					</tr>
					<tr>
						<td class="title" rowspan="3">��<br>��<br>��</td>
						<td class="title" colspan="2">�ܰ�(��)</td>
						<%if(papyl_fm){%><td class="td_style" align="right">1,200</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">500</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">500</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">500</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">500</td><%}%>
						<%if(acta2_fm){%><td class="td_style" align="right">1,000</td><%}%>
						<td class="td_style" align="right"></td>
					</tr>
					<tr>
						<td class="title" colspan="2">����(��)</td>
						<%if(papyl_fm){%><td class="td_style" align="right">1,000 </td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">500</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">500</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">1,000</td><%}%>
						<%if(acta2_fm){%><td class="td_style" align="right">500</td><%}%> <!-- 2020-10 ���� �⺻ 500�� 300,000�� -->
						<td class="td_style" align="right"><!-- 2,300 -->
						<%	int tot_cnt = 0;
								if(papyl_fm){	tot_cnt += 1000;	}
								if(acta1_fm){	tot_cnt += 1000;	}
								if(acta2_fm){	tot_cnt += 500;	}
						%>
							<%=AddUtil.parseDecimal(tot_cnt) %>
						</td>
					</tr>
					<tr>
						<td class="title" colspan="2">�⺻���(��,��)</td>
						<%if(papyl_fm){%><td class="td_style" align="right">1,200,000</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">250,000</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">250,000</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">500,000</td><%}%>
						<%if(acta2_fm){%><td class="td_style" align="right">300,000</td><%}%>
						<td class="td_style" align="right"><!-- 2,000,000 -->
						<%	int tot_fee = 0;
								if(papyl_fm){	tot_fee += 1200000;	}
								if(acta1_fm){	tot_fee += 500000;	}
								if(acta2_fm){	tot_fee += 300000;	}
						%>
							<%=AddUtil.parseDecimal(tot_fee) %>
						</td>
					</tr>
					<tr>
						<td class="title" rowspan="4">��<br>��<br>��<br>��</td>
						<td class="title" colspan="2">�ܰ�(��)</td>
						<%if(papyl_fm){%><td class="td_style" align="right">1,200</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">400</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">400</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">400</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">400</td><%}%>
						<%if(acta2_fm){%><td class="td_style" align="right">1,000</td><%}%>
						<td class="td_style" align="right"></td>
					</tr>
					<tr>
						<td class="title" colspan="2">�ǻ�뷮</td>
						<%if(papyl_fm){%><td class="td_style" align="right"><%=papylCnt%></td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right"><%=t_cnt1%></td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right"><%=t_cnt2%></td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right"><%=t_cnt4%></td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right"><%=t_cnt1 + t_cnt2 + t_cnt4%></td><%}%>
						<%if(acta2_fm){%><td class="td_style" align="right"><%=t_cnt3%></td><%}%>
						<td class="td_style" align="right"><%=papylCnt + t_cnt1 + t_cnt2 + t_cnt3 + t_cnt4%></td>
					</tr>
					<tr>
						<td class="title" rowspan="2">�ʰ����</td>
						<td class="title">����</td>
						<%if(papyl_fm){%><td class="td_style" align="right">-</td><%}%>
						<%if(acta1_fm){%><td class="title" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="title" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="title" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right"><%if(t_cnt1_over + t_cnt2_over + t_cnt4_over > 0){%><%=t_cnt1_over + t_cnt2_over + t_cnt4_over%><%}else{%>0<%}%></td><%}%>
						<%if(acta2_fm){%><td class="td_style" align="right"><%if(t_cnt3_over > 0){%><%=t_cnt3_over%><%}else{%>0<%}%></td><%}%>
						<td class="td_style" align="right"><%if(t_cnt1_over + t_cnt2_over + t_cnt3_over + papylCnt_over + t_cnt4_over > 0){%><%=papylCnt_over + t_cnt1_over + t_cnt2_over + t_cnt3_over + t_cnt4_over%><%}else{%>0<%}%></td>
					</tr>
					<tr>
						<td class="title">���</td>
						<%if(papyl_fm){%><td class="td_style" align="right">-</td><%}%>
						<%if(acta1_fm){%><td class="title" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="title" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="title" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right"><%if(t_cnt1_over + t_cnt2_over + t_cnt4_over>0){%><%=AddUtil.parseDecimal(400*(t_cnt1_over + t_cnt2_over + t_cnt4_over))%><%}else{%>0<%}%></td><%}%>
						<%if(acta2_fm){%><td class="td_style" align="right"><%if(t_cnt3_over>0){%><%=AddUtil.parseDecimal(1000*t_cnt3_over)%><%}else{%>0<%}%></td><%}%>
						<td class="td_style" align="right"><%if(papylCnt_over + t_cnt1_over + t_cnt2_over + t_cnt3_over + t_cnt4_over>0){%><%=AddUtil.parseDecimal((400*(papylCnt_over + t_cnt1_over + t_cnt2_over + t_cnt4_over))+(1000*t_cnt3_over))%><%}else{%>0<%}%></td>
					</tr>
					<tr>
						<td class="title" colspan="3">�����(VAT����)</td>
						<%if(papyl_fm){%><td class="td_style" align="right"><%=AddUtil.parseDecimal(1200000 + (1200*papylCnt_over))%></td><%}%>
						<%if(acta1_fm){%><td class="title" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="title" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="title" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right"><%if(t_cnt1_over + t_cnt2_over + t_cnt4_over>0){%><%=AddUtil.parseDecimal(500000 + (400*(t_cnt1_over + t_cnt2_over + t_cnt4_over)))%><%}else{%>500,000<%}%></td><%}%>
						<%if(acta2_fm){%><td class="td_style" align="right"><%if(t_cnt3_over>0){%><%=AddUtil.parseDecimal(300000 + (1000*t_cnt3_over))%><%}else{%>300,000<%}%></td><%}%>
						<td class="td_style" align="right">
							<%-- <%if(t_cnt1_over + t_cnt2_over>0||t_cnt3_over>0){%><%=AddUtil.parseDecimal(1200000 + 500000 + (400*(t_cnt1_over + t_cnt2_over)) + (1200*papylCnt_over) + (1000*t_cnt3_over))%><%}else{%>2,000,000<%}%> --%>
						<%	int tot_amt = 0;		//�հ豸�ϱ�
						 		if(papylCnt > 0){								tot_amt += 1200000;											}
						 		if(papylCnt_over > 0){						tot_amt += (1200 * papylCnt_over);					}
						 		if(t_cnt1 + t_cnt2 > 0){					tot_amt += 500000;												}
								if(t_cnt1_over + t_cnt2_over + t_cnt4_over>0){		tot_amt += (400 * (t_cnt1_over + t_cnt2_over + t_cnt4_over));	}
								if(t_cnt3 > 0){									tot_amt += 300000;												}
								if(t_cnt3_over > 0){							tot_amt += 1000 * t_cnt3_over;							}
						%>
							<%=AddUtil.parseDecimal(tot_amt) %>	
						</td>
					</tr>
				</tbody>
			</table>
		</td>
	</tr>
	<tr> 
        <td class=h height="40px;" style="text-align: right; padding-top: 5px;">�� û�� �ݾ׿��� �� �ݾ׿� SMS �̿��� �޴��� ���� �����ᰡ �߰��˴ϴ�.</td>
    </tr>
</table>
<!-- <div style="margin-top: 10px;"><small>�� �ʰ���뷮�� �������Ͻ� 0���� ó���߱� ������ ����Ʈ, �ε��μ��� ����� ����ó�� ���ϼ��ֽ��ϴ�. (�Ұ�� ��Ȯ�� ��ġ)</small></div> -->
<%if(acta2_fm){%>
<table border="0" cellspacing="0" cellpadding="0" width=30%>
    <tr> 
        <td class=h height="40px;">&nbsp;</td>
    </tr>
    <tr>
	    <td class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<colgroup>
            		<col width="20%">
            		<col width="30%">
            		<col width="30%">
            		<col width="30%">
            	</colgroup>
            	<tr>
            		<td colspan="4" class="title" style="padding: 5px 0;">(��)��Ÿ����Ʈ ��༭<br>(���뿩) ���γ���</td>
            	</tr>	
            	<tr>
            		<td class="title">����</td>
            		<!-- <td class="title">�Ϸ�Ǽ�</td>
            		<td class="title">��ϰǼ�</td> -->
            		<td class="title">�߼�(�Ǽ�)</td>
            		<td class="title">ü��(�Ǽ�)</td>
            		<td class="title">���/����(�Ǽ�)</td>
            	</tr>
            	<tr>
            		<td class="title">�ű�</td>
            		<td align="center"><%=ht4.get("CNT1")%></td>
            		<td align="center"><%=ht3.get("CNT1")%></td>
            		<td align="center"><%=Integer.parseInt(String.valueOf(ht4.get("CNT1")))-Integer.parseInt(String.valueOf(ht3.get("CNT1")))%></td>
            	</tr>
            	<tr>
            		<td class="title">����</td>
            		<td align="center"><%=ht4.get("CNT2")%></td>
            		<td align="center"><%=ht3.get("CNT2")%></td>
            		<td align="center"><%=Integer.parseInt(String.valueOf(ht4.get("CNT2")))-Integer.parseInt(String.valueOf(ht3.get("CNT2")))%></td>
            	</tr>
            	<tr>
            		<td class="title">����</td>
            		<td align="center"><%=ht4.get("CNT3")%></td>
            		<td align="center"><%=ht3.get("CNT3")%></td>
            		<td align="center"><%=Integer.parseInt(String.valueOf(ht4.get("CNT3")))-Integer.parseInt(String.valueOf(ht3.get("CNT3")))%></td>
            	</tr>
            	<tr>
            		<td class="title">�հ�</td>
            		<td align="center">           		
            			<%=AddUtil.parseLong(String.valueOf(ht4.get("CNT1")))+AddUtil.parseLong(String.valueOf(ht4.get("CNT2")))+AddUtil.parseLong(String.valueOf(ht4.get("CNT3")))%>            	
            		</td>
            		<td align="center">
           		<%	
            		if(h3_cnt_tot == t_cnt3+t_cnt4){ %>	
            			<%=t_cnt3+t_cnt4%>
            	<%}else{%>
            			<%=h3_cnt_tot %><br>
<!--             			(��ī��Ʈ���� ��ġ���� �ʽ��ϴ�. ���й��ֿ� ���� �ٸ��� ǥ�õɼ� �ֽ��ϴ�. �������� Ȯ�ο�û ���ּ���.<br> -->
<!--             			2019�� 5���� �����ʹ� �׽�Ʈ������ ������ 6�� ���̳��ϴ�.) -->
            	<%} %>		
            		</td>
            		<td align="center">
            			<%=(AddUtil.parseLong(String.valueOf(ht4.get("CNT1")))+AddUtil.parseLong(String.valueOf(ht4.get("CNT2")))+AddUtil.parseLong(String.valueOf(ht4.get("CNT3")))) - (t_cnt3+t_cnt4)%>
            		</td>
            	</tr>
           	</table>
    	</td>
   	</tr>
</table>	
<%}%>
</form>
</body>
</html>
