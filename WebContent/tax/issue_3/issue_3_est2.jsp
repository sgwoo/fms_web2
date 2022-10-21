<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, tax.*, acar.bill_mng.*, acar.client.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	int tae_sum = 0;
	int max_table_line = 3;
	int height = 0;
	String tax_supply = "";
	String tax_value = "";
	String tax_yn= "N";
	
	//�ܱ�뿩 ������
	Vector grts = ScdMngDb.getSRentScdList(s_br, "", tax_yn);
	int grt_size = grts.size();	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function client_select(client_id, site_id, firm_nm, car_mng_id, rent_l_cd){
		var fm = document.form1;
		fm.client_id.value = client_id;	
		fm.site_id.value = site_id;
		fm.firm_nm.value = firm_nm;
		fm.car_mng_id.value = car_mng_id;
		fm.rent_l_cd.value = rent_l_cd;
		fm.action = "issue_3_sc2.jsp";
		fm.target = "d_content";
		fm.submit();
	}
//-->
</script>

</head>
<body>
<form action="./issue_3_sc_a.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="client_id" value="<%=client_id%>">
  <input type="hidden" name="site_id" value="<%=site_id%>">  
  <input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">      
  <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">  
  <input type="hidden" name="mode" value="<%=mode%>">  
  <input type="hidden" name="firm_nm" value="">  
<table width=100% border=0 cellpadding=0 cellspacing=0>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ܱ�뿩 �̹��ฮ��Ʈ</span></td>
    </tr>  
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr>
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>      	
                <tr>
                  <td width='3%' class='title'>����</td>
                  <td width='6%' class='title'>��౸��</td>
                  <td width='6%' class='title'>��ݱ���</td>
                  <td width='6%' class='title'>����ȣ</td>
                  <td width='10%' class='title'>��ȣ</td>
                  <td width='8%' class='title'>������ȣ</td>
                  <td width='8%' class='title'>����</td>
                  <td width='8%' class='title'>���ް�</td>
                  <td width='6%' class='title'>�ΰ���</td>
                  <td width='8%' class='title'>�հ�</td>
                  <td width='7%' class='title'>��������</td>
                  <td width='7%' class='title'>��������</td>				  
                  <td width='7%' class='title'>�Աݿ�����</td>
                  <td width='7%' class='title'>��������</td>
                  <td width='3%' class='title'>-</td>
                </tr>
		<%	if(grt_size > 0){
				for (int i = 0 ; i < grt_size ; i++){
					Hashtable grt = (Hashtable)grts.elementAt(i);%>		
                <tr>
                  <td align="center"><%=i+1%></td>
                  <td align="center"><%=grt.get("RENT_ST_NM")%></td>		  
                  <td align="center"><%=grt.get("SCD_RENT_ST_NM")%></td>		  
                  <td align="center"><a href="javascript:client_select('<%=grt.get("CLIENT_ID")%>','','<%=grt.get("FIRM_NM")%>','<%=grt.get("CAR_MNG_ID")%>','<%=grt.get("RENT_S_CD")%>')"><%=grt.get("RENT_S_CD")%></a></td>
                  <td align="center"><span title='<%=grt.get("FIRM_NM")%>(<%=grt.get("CLIENT_ID")%>)'><%=AddUtil.subData(String.valueOf(grt.get("FIRM_NM")), 6)%></td>
                  <td align="center"><%=grt.get("CAR_NO")%></td>
                  <td align="center"><span title='<%=grt.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(grt.get("CAR_NM")), 5)%></td>
                  <td align="right"><%=Util.parseDecimal(String.valueOf(grt.get("RENT_S_AMT")))%>��</td>
                  <td align="right"><%=Util.parseDecimal(String.valueOf(grt.get("RENT_V_AMT")))%>��</td>
                  <td align="right"><%=Util.parseDecimal(String.valueOf(grt.get("RENT_AMT")))%>��</td>
                  <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(grt.get("DELI_DT")))%></td>
                  <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(grt.get("RET_DT")))%></td>				  
                  <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(grt.get("EST_DT")))%></td>
                  <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(grt.get("PAY_DT")))%></td>	
                  <td align="center">-</td>			  
                </tr>
		<%		}
			}%>
<% 		if(grt_size == 0){%>
        		<tr>
        		  <td colspan="15" align="center">��ϵ� ����Ÿ�� �����ϴ�.</td>
        		</tr>
<% 		}%>								
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>	
</table>
</form>
</body>
</html>
