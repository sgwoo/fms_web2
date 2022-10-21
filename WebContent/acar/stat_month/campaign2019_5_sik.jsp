<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*, acar.estimate_mng.*"%>
<jsp:useBean id="cmp_db" scope="page" class="acar.stat_bus.CampaignDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String loan_st 		= request.getParameter("loan_st")==null?"":request.getParameter("loan_st");
	String save_dt 		= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String bus_down_per 	= request.getParameter("bus_down_per")==null?"":AddUtil.ChangeString(request.getParameter("bus_down_per"));
	String mng_down_per 	= request.getParameter("mng_down_per")==null?"":AddUtil.ChangeString(request.getParameter("mng_down_per"));
	String cs_dt 		= request.getParameter("cs_dt")==null?"":AddUtil.ChangeString(request.getParameter("cs_dt"));
	String ce_dt 		= request.getParameter("ce_dt")==null?"":AddUtil.ChangeString(request.getParameter("ce_dt"));
	String bs_dt 		= request.getParameter("bs_dt")==null?"":AddUtil.ChangeString(request.getParameter("bs_dt"));
	String be_dt 		= request.getParameter("be_dt")==null?"":AddUtil.ChangeString(request.getParameter("be_dt"));
	String bs_dt2 		= request.getParameter("bs_dt2")==null?"":AddUtil.ChangeString(request.getParameter("bs_dt2"));
	String be_dt2 		= request.getParameter("be_dt2")==null?"":AddUtil.ChangeString(request.getParameter("be_dt2"));
	
	
	//����ķ���κ��� : campaign ���̺�
	Hashtable ht = cmp_db.getCampaignVar();
	
	String ns_dt1		= (String)ht.get("NS_DT1");
	String ns_dt2		= (String)ht.get("NS_DT2");
	String ns_dt3		= (String)ht.get("NS_DT3");
	String ns_dt4		= (String)ht.get("NS_DT4");
	String ne_dt1		= (String)ht.get("NE_DT1");
	String ne_dt2		= (String)ht.get("NE_DT2");
	String ne_dt3		= (String)ht.get("NE_DT3");
	String ne_dt4		= (String)ht.get("NE_DT4");
	String enter_dt		= (String)ht.get("ENTER_DT");
	
	
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_bus_cmp");
	
	
	Vector vt1 = new Vector();	
		
	vt1 = cmp_db.getCampaignSik_2019_05(save_dt, loan_st);
	
	int size1 	= vt1.size();	
	
		
	String sum_cnt1= "", avg_cnt1= "", sum_r_cnt= "", avg_r_cnt= "", sum_bus= "", sum_bus_1= "", sum_bus_2= "", avg_bus= "", avg_bus_1= "", avg_bus_2= "", avg_low_bus = "";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
</head>

<body leftmargin='15'>
  
<table width="960" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�濵���� > ķ���ΰ��� > ����ķ���� > <span class=style5>���ĺ���</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <% 	if(size1>0){%>
    <tr>
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=loan_st%>��</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td class="line">
                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                          <tr>
                            <td width="30" rowspan="3" class="title">����</td>
                            <td width="60" rowspan="3" class="title">�����</td>
                            <td colspan="8" class="title">ķ���αⰣ(<%= AddUtil.ChangeDate2(cs_dt) %> ~ <%= AddUtil.ChangeDate2(ce_dt) %>)</td>
                          </tr>
                          <tr>
                            <td width="60" rowspan="2" class="title">�򰡱���(����6�����������)</td>
                            <td colspan="2" class="title">�������</td>
                            <td width="80" rowspan="2" class="title">����ȿ��<br>
                              ��ȿ����</td>
                            <td width="80" rowspan="2" class="title">ķ���ν���</td>
                            <td width="60" rowspan="2" class="title">�޼���</td>
                            <td width="80" rowspan="2" class="title">����ݾ�</td>
                          </tr>
                          <tr>
                            <td width="70" class="title">�ѽ���</td>
                            <td width="70" class="title">��ȿ����</td>
                          </tr>
                          <% 	for(int i=0; i<size1; i++){
            				Hashtable ht3 = (Hashtable)vt1.elementAt(i);
						if(i==0){
	            					sum_cnt1 	= (String)ht3.get("SUM_CNT1");
    	        					avg_cnt1 	= (String)ht3.get("AVG_CNT1"); 
        	    					sum_r_cnt 	= (String)ht3.get("SUM_R_CNT");
            						avg_r_cnt 	= (String)ht3.get("AVG_R_CNT"); 
            						sum_bus 	= (String)ht3.get("SUM_BUS");
            						sum_bus_1 	= (String)ht3.get("SUM_BUS_1");
            						sum_bus_2 	= (String)ht3.get("SUM_BUS_2");
            						avg_bus 	= (String)ht3.get("AVG_BUS");
            						avg_bus_1 	= (String)ht3.get("AVG_BUS_1");
            						avg_bus_2 	= (String)ht3.get("AVG_BUS_2");
            						avg_low_bus 	= (String)ht3.get("AVG_LOW_BUS");
						}
            		  %>
                          <tr>
                            <td align="center"><%= i+1 %></td>
                            <td align="center"><%= ht3.get("USER_NM") %></td>
                            <td align="right"><%= ht3.get("CMP_DISCNT_PER") %></td>
                            <td align="right"><%= ht3.get("C_CNT") %></td>
                            <td align="right"><%= ht3.get("CR_CNT2") %></td>
                            <td align="right"><%= ht3.get("C_COST_CNT") %></td>
                            <td align="right"><%= ht3.get("C_TOT_CNT") %></td>
                            <td align="right"><%= ht3.get("ORG_DALSUNG") %></td>
                            <td align="right"><%= AddUtil.parseDecimal((String)ht3.get("AMT2")) %></td>
                          </tr>
                          <% 	} %>

                        </table></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td style='height:14'><font color="#999999">�� �⺻��ǥ = ���� 6���� �ش籺 ������ ķ���ν��� * [��ǥ����ġ]</font></td>
    </tr>
    <tr> 
        <td style='height:14'><font color="#999999">�� ķ���� ������ ���� �Ի� <%if(loan_st.equals("1")){%>48����<%}else{%>36����<%}%> �̻� : ���θ�ǥ = �⺻��ǥ</font></td>
    </tr>
    <tr> 
        <td style='height:14'><font color="#999999">�� ķ���� ������ ���� �Ի� <%if(loan_st.equals("1")){%>48����<%}else{%>36����<%}%> �̸��� : ���θ�ǥ = �⺻��ǥ �� {1 - ( [�������� 1������ ������] �� (<%if(loan_st.equals("1")){%>48<%}else{%>36<%}%> - ķ���� ������ ���� �Ի� ������) )}</font></td>
    </tr>
    <tr> 
        <td style='height:14'><font color="#999999">�� �򰡱���: ���θ�ǥ </font></td>
    </tr>
    <tr> 
        <td style='height:14'><font color="#999999">�� ķ���ν��� : (ķ���αⰣ ������� ��ȿ������� * �����������ġ) + (ķ���αⰣ ����ȿ����� ��ȿ������� * ����ȿ���������ġ)</font></td>
    </tr>
    <tr> 
        <td style='height:14'><font color="#999999">�� �޼��� : ķ���ν��� / �򰡱��� (�ִ�޼����� �ʰ��ϸ� �ִ�޼����� �Ѵ�.)</font></td>
    </tr>
    <tr> 
        <td style='height:14'><font color="#999999">�� ����ݾ� : ķ���αⰣ ������� * ����޼��� * �������ݾ� * ����ݾ�������</font></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
<% } %>  


    <tr> 
        <td>&nbsp;</td>
    </tr>
</table>
</body>
</html>
