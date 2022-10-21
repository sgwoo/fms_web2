<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.doc_settle.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	String pur_pay_dt = pur.getPur_pay_dt();
	
	if(pur_pay_dt.equals(""))	pur_pay_dt = pur.getPur_est_dt();
	
	if(pur_pay_dt.equals(""))	pur_pay_dt = pur.getCon_est_dt();
	
	
	Vector vt = d_db.getCarPurPayEstDtList("", pur_pay_dt);
	int vt_size = vt.size();
	
	Vector vt2 = d_db.getCarPurPayEstDtStat(pur_pay_dt);
	int vt_size2 = vt2.size();
	
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
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
	long total_amt15 = 0;
	long total_amt16 = 0;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
		
//-->
</script>
</head>

<body leftmargin="15">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������� > <span class=style5>������ݰ���(����)�ݾ�</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
    <tr>
      <td>[��������] <%=AddUtil.ChangeDate2(pur_pay_dt)%></td>
    </tr>  	
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  	
    <tr>
      <td class='line'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
			<td width='3%' class='title'>����</td>
		    <td width='10%' class='title'>����ȣ</td>
		    <td width="20%" class='title'>��</td>
		    <td width="7%" class='title'>�������</td>			
			<!--<td width='8%' class='title'>������ȣ</td>-->
		    <td width="10%" class='title'>����</td>					
       		<td width='14%' class='title'>����ó</td>
			<td width="6%" class='title'>���޼���</td>
		    <td width="9%" class='title'>�ݾ�</td>								
			<td width="6%" class='title'>����</td>				  
			<td width="15%" class='title'>��ȣ</td>
		  </tr>		
		  <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
		  %>
		  <tr>
			<td align='center'><%=i+1%></td>
		    <td align='center'><%=ht.get("RENT_L_CD")%></td>
		    <td align='center'><%=ht.get("FIRM_NM")%></td>
		    <td align='center'><%=ht.get("DLV_DT")%></td>			
			<!--<td align='center'><%=ht.get("CAR_NO")%></td>-->
       		<td align='center'><%=ht.get("CAR_NM")%></td>					
       		<td align='center'><font color="#CCCCCC"><%=c_db.getNameById(String.valueOf(ht.get("CAR_COMP_ID")),"CAR_COM")%></font><br><%=ht.get("DLV_BRCH")%></td>
			<td align='center'><%=ht.get("TRF_ST")%></td>
			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT")))%></td>
			<td align='center'><%=ht.get("CARD_KIND")%></td>
			<td align='center'><%=ht.get("CARDNO")%></td>						
		  </tr>
		  <%		total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("TRF_AMT")));
		 		}%>
		  <tr>
		    <td colspan="7" class=title>�հ�</td>
		    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>		
			<td class='title'></td>									
			<td class='title'></td>												
		  </tr>
		</table>
	  </td>
    </tr> 
    <tr>
      <td class=h></td>
    </tr>  
    <tr>
        <td><< ī�����������ǥ >></td>
    </tr>  
	<tr>
	    <td>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>		  
        			<td class=line>
        			    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        			        <tr>
        			            <td class=line2 style='height:1' colspan=11></td>
        			        </tr>
                            <tr valign="middle" align="center">
                                <td width='3%' rowspan="3" class=title>����</td>
                                <td width='15%' rowspan="3" class=title>ī����</td>
                                <td width='13%' rowspan="3" class=title>ī���ȣ</td>
                                <td width='3%' rowspan="3" class=title>����<br>����</td>
                                <td colspan="5" class=title>�ŷ�����</td>
                                <td width='18%' rowspan="3" class=title>��ġ�Ⱓ</td>
                            </tr>
                            <tr valign="middle" align="center">
				<td colspan="2" class=title>���ϰŷ��ݾ�</td>
                                <td colspan="3" class=title>��������ŷ��ݾ�</td>
                            </tr>
                            <tr valign="middle" align="center">
				<td width='10%' class=title>�ݾ�</td>
                                <td width='8%' class=title>����������</td>
                                <td width='10%' class=title>������ݾ�</td>
                                <td width='10%' class=title>�̰����ݾ�</td>
                                <td width='10%' class=title>�հ�</td>
                            </tr>                                                        
        		    <%	
        			for(int i = 0 ; i < vt_size2 ; i++){
        				Hashtable ht = (Hashtable)vt2.elementAt(i);
        				String cardno 		= String.valueOf(ht.get("CARDNO"));
        				String trf_st 		= String.valueOf(ht.get("TRF_ST"));
        				String use_s_m 		= String.valueOf(ht.get("USE_S_M"));
        				String use_s_day 	= String.valueOf(ht.get("USE_S_DAY"));
        				String use_e_m 		= String.valueOf(ht.get("USE_E_M"));
        				String use_e_day 	= String.valueOf(ht.get("USE_E_DAY"));        						
        				//���ϰŷ��ݾ�
					long d_pay_amt 		= AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT")));
					//��������ŷ��ݾ�
					long m_pay_amt 		= d_db.getCarPurPayCardAmt(cardno, trf_st);
					//��������ŷ��ݾ�
					Hashtable mon_amt_ht 	= d_db.getCarPurPayMonCardAmt(cardno, trf_st, String.valueOf(ht.get("PUR_EST_DT")));
        		    %>	
                            <tr valign="middle" align="center">
                                <td><%=i+1%></td>
                                <td><%=ht.get("COM_NAME")%></td>
                                <td><%=cardno%></td>
                                <td><%=trf_st%></td>
				<td align="right"><%=Util.parseDecimal(d_pay_amt)%></td>
				<td><%=AddUtil.ChangeDate2(af_db.getValidDt(String.valueOf(ht.get("PAY_DT"))))%></td>
				<td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(mon_amt_ht.get("AMT1"))))%></td>
				<td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(mon_amt_ht.get("AMT2"))))%></td>
                                <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(mon_amt_ht.get("T_AMT"))))%><%//=Util.parseDecimal(m_pay_amt)%></td>
                                <td>
                                    <!--<%if(String.valueOf(ht.get("CARD_KIND")).equals("�Ｚī��")){%>������ ���� �����ð�<%}%>20151209������1�����Ϸ� ����->20160217 ������2�����Ϸ� ����-->
                                    <!--<%if(String.valueOf(ht.get("CARD_KIND")).equals("�Ｚī��")){%>������ 2������(���Ϻһ���)<%}%> 20170712  2������->3������ ����--> 
                                    <%if(String.valueOf(ht.get("CARD_KIND")).equals("�Ｚī��")){%>������ 4������(���Ϻһ���)<%}%>
                                    <%if(String.valueOf(ht.get("CARD_KIND")).equals("�츮BCī��")||String.valueOf(ht.get("CARD_KIND")).equals("�λ��ī��")||String.valueOf(ht.get("CARD_KIND")).equals("����ī��")){%>������ 3������(���Ϻһ���)<%}%>
                                    <%if(String.valueOf(ht.get("CARD_KIND")).equals("����ī��")){%>������ 2������(���Ϻһ���)<%}%>
                                    <!--<%if(String.valueOf(ht.get("CARD_KIND")).equals("����ī��")){%>������ 1������(���Ϻһ���)<%}%>-->
                                    <%if(String.valueOf(ht.get("CARD_KIND")).equals("����ī��")){%>1�ְ� ���ΰ� �ջ��� ���� ������<%}%>
                                </td>								
                            </tr>
        		    <%		total_amt14 = total_amt14 +d_pay_amt;
        				total_amt15 = total_amt15 +m_pay_amt;
        		      	}
        		    %>
                            <tr valign="middle" align="center">
                                <td colspan="4" class=title>�հ�</td>
                                <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt14)%></td>
                                <td class=title></td>
                                <td class=title></td>
                                <td class=title></td>
            			<td class=title style='text-align:right'><%=Util.parseDecimal(total_amt15)%></td>
            			<td class=title></td>								
                            </tr>				
                        </table>			
        	    </td>	        	    
                </tr>	
            </table>		  
	    </td>	
	</tr>
	
</table>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

