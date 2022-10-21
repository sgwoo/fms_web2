<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.stat_bus.*"%>
<jsp:useBean id="cmp_db" scope="page" class="acar.stat_bus.CampaignDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	String user_nm 	= request.getParameter("user_nm")	==null?"":request.getParameter("user_nm");
	String bus_id 	= request.getParameter("bus_id")	==null?"":request.getParameter("bus_id");
	String cs_dt 	= request.getParameter("cs_dt")		==null?"":AddUtil.ChangeString(request.getParameter("cs_dt"));
	String ce_dt 	= request.getParameter("ce_dt")		==null?"":AddUtil.ChangeString(request.getParameter("ce_dt"));
	String bs_dt 	= request.getParameter("bs_dt")		==null?"":AddUtil.ChangeString(request.getParameter("bs_dt"));
	String be_dt 	= request.getParameter("be_dt")		==null?"":AddUtil.ChangeString(request.getParameter("be_dt"));	
	
	
	Vector vt = cmp_db.getStatBusCmpBaseBusList_2014_05(bus_id, "c", bs_dt, be_dt, cs_dt, ce_dt);
	
	
	float cnt3 	= 0.0f;
	float cnt4	= 0.0f;
	float v_cnt4 	= 0.0f;
		
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>

<body>
<table width="1050" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
      <table width=100% border=0 cellpadding=0 cellspacing=0>
        <tr>
          <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
          <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�濵���� > ķ���ΰ��� > ����ķ���� > <span class=style5>����ķ���� ����</span></span></td>
          <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td class=h></td>
  </tr>
  <tr> 
    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=user_nm%></span></td>
  </tr>
  <tr>
    <td class=line2></td>
  </tr>
  <tr> 
    <td width="100%" class="line">
      <table width="100%" border="0" cellspacing="1" cellpadding="0">
        <tr> 
          <td width="30" class="title">����</td>
          <td width="55" class="title">��౸��</td>		  
          <td width="95" class="title">����ȣ</td>
          <td width="210" class="title">��ȣ</td>
          <td width="70" class="title">�ŷ�������</td>
          <td width="65" class="title">����</td>
          <td width="50" class="title">����<br>�����</td>
          <td width="50" class="title">����<br>�븮��</td>
          <td width="50" class="title">����<br>�����</td>		  		  
          <td width="30" class="title">����<br>���</td>		  		  
          <td width="40" class="title">�뿩<br>����</td>		  		  
          <td width="30" class="title">���<br>����</td>		  		  		            
          <td width="70" class="title">�뿩������</td>
          <td width="70" class="title">������</td>		  
          <td width="45" class="title">����<br>����<br>���</td>
          <td width="45" class="title">��ȿ<br>����</td>
          <td width="45" class="title">����<br>����</td>		  
        </tr>
        <%	if(vt.size()>0){
			for(int i=0; i<vt.size(); i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
	%>
        <tr> 
          <td align="center"><%= i+1 %></td>
          <td align="center"><%= ht.get("GUBUN") %></td>
          <td align="center"><%= ht.get("RENT_L_CD") %></td>
          <td>&nbsp;<%= ht.get("FIRM_NM") %></td>
          <td align="center"><%= AddUtil.ChangeDate2((String)ht.get("FIRST_RENT_START_DT")) %></td>          
          <td align="center"><%= ht.get("GUBUN2") %></td>		  
          <td align="center"><%= ht.get("BUS_NM") %><%if(String.valueOf(ht.get("BUS_NM")).equals("")){%><%=c_db.getNameById(String.valueOf(ht.get("F_BUS_ID")),"USER")%><%}%></td>
          <td align="center"><%= ht.get("BUS_AGNT_NM") %></td>		  
          <td align="center"><%= ht.get("BUS_NM2") %></td>		  		  
          <td align="center"><%= ht.get("BUS_EMP_ID_YN") %></td>		  		  
          <td align="center"><%= ht.get("RENT_WAY_NM") %></td>		  		  		  
          <td align="center"><%= ht.get("CON_MON") %></td>		  		  		            
          <td align="center"><%= AddUtil.ChangeDate2((String)ht.get("RENT_START_DT")) %></td>
          <td align="center"><%= AddUtil.ChangeDate2((String)ht.get("CLS_DT")) %></td>		            
          <td align="center"><%= ht.get("CC_CNT3") %></td>
          <td align="center"><%= ht.get("CC_CNT4") %></td>
          <td align="center"><%= ht.get("RR_CNT4") %></td>
        </tr>
        <% 			cnt3 	= cnt3	+ AddUtil.parseFloat((String)ht.get("CC_CNT3"));
				cnt4 	= cnt4 	+ AddUtil.parseFloat((String)ht.get("CC_CNT4"));
				v_cnt4 	= v_cnt4+ AddUtil.parseFloat((String)ht.get("RR_CNT4"));				
			}
	%>
        <tr> 
          <td colspan="14" class="title">&nbsp;</td>          
          <td align="center"><%= AddUtil.parseFloatCipher(cnt3,2) %></td>
          <td align="center"><%= AddUtil.parseFloatCipher(cnt4,2) %></td>
          <td align="center"><%= AddUtil.parseFloatCipher(v_cnt4,2) %></td>
        </tr>
        <%	}else{	 %>
        <tr> 
          <td colspan="16"><div align="center">�ش� �����Ͱ� �����ϴ�.</div></td>
        </tr>
        <% 	} %>				
            </table>
    </td>
    </tr>
</table>
<p>
  <font color="#999999" style="font-size : 9pt;">
  <br>
  �� ķ���� ������� ������� = ���� ��������հ� * �ѽ����μ����հ� / ��������μ����հ� 
  <br>
  �� ķ���� ���� ����Ÿ�Դϴ�. �ǽð� ����Ÿ�� Ʋ�� �� �ֽ��ϴ�.
  <!--
  <br>  
  �� ����������� : �������� ��������� ��ȿ���� ����. 
  <br>
  �� �����븮�� : �����븮���� �ִ� ��� ���ʿ����ڴ� 0.75, �����븮���� 0.25�� ��������.(2011��03��23�� ���� ���)
  <br>  
  �� [2011-03-30 ����] �����븮�� �����̰� ���� ���� ���� : 2011��03��23�� ���� ���� �����븮�ο��� ��� 1�� ��ü�� �ְ�, ���ʿ����ڴ� ����ȿ���� 100% ���´�.
  <br>   
  �� ��������� : �Ϲݽ� �뿩������ �� 1���� ���� ��ü����  �Ϲݽ� ����,����,�������� ���� �� ��༭�� �� ���(FMS�� ���ʿ�����)�� 
  <br>
  &nbsp;&nbsp;&nbsp;�� ������ ������ ���(FMS�� ���������)�� �ٸ� ��쿡�� ķ���� ������ ������� 0.5�븦, FMS�� ��������ڿ��� �ѱ��.(�������: 11�� 12�� ���� ����)
  <br>  
  �� [2010-07-15 ����] ������� ī���� ���� ���� : 6����~11���� ���� 0.5�� / 12�����̻� ���� 1��� ī��Ʈ �˴ϴ�.
  <br> 
  �� ��ȿ����
  <br> 
  &nbsp;&nbsp;&nbsp;�� �縮�� 1.5��
  <br> 
  &nbsp;&nbsp;&nbsp;�� �뷮������ ��� 5�� �ʰ� ���� 50%�� �����ϰ� ���Ͼ�ü�� ���� �ִ� 10����� ��������.
  <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(��: 1��:1, 2��:2, 3��:3, 4��:4, 5��:5, 6��:5.5, 7��:6, 8��:6.5, 9��:7, 10��:7.5, 11��:8, 12��:8.5, 13��:9, 14��:9.5, 15��:10..) 
  <br> 
  &nbsp;&nbsp;&nbsp;�� �뷮������ ��� ������ �縮���� �������ڿ� �ִ� ��� �縮���� �켱 ī��Ʈ�Ѵ�.
  <br> 
  &nbsp;&nbsp;&nbsp;�� �뷮������ ��� ���� �Ϻΰ� ��������� �� ������������ ���� ��� �������� ���߿� �Է��Ѱ����� ����.  
  <br> 
  -->
  <br>  
  �� �뿩������ �������� ������ ī��Ʈ�˴ϴ�.
  <br>  
  �� ���ο������ : ���ʰ���� ����, 6���� �̻� ��ุ 1��� ī��Ʈ
  <br> 
  �� ��ȿ����
  <br> 
  &nbsp;&nbsp;&nbsp;- ���� : ��������� ������ 1��, ��ü���� 2��, �÷������̺긮�� +1��, ���� +2��, �űԴ� +0.5��(�ű� �ټ��� 1�븸 ����)
  <br> 
  &nbsp;&nbsp;&nbsp;- �縮�� : 24�����̻� 2��, 12���� �̻� 1.5��, 6~11���� 1��
  <br>
  &nbsp;&nbsp;&nbsp;- ���� : 6���� �̻� 0.5��
  <br> 
  &nbsp;&nbsp;&nbsp;�� �뷮����ó (ķ���� �Ⱓ�� 6�� �̻� �뿩���� ��) : 5�� �ʰ� ���� 50%�� �����ϰ� ���Ͼ�ü�� ���� �ִ� 15��° �뿩���� �Ǳ��� ���� ����
  <br> 
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(�� �뿩������ ������ 5������� 100%, 6~15��� 50% ����  �� ������ �縮���� �������ڿ� �ִ� ��� �縮���� �켱 ī��Ʈ�Ѵ�.)
  <br> 
  &nbsp;&nbsp;&nbsp;- ����Ʈ : �ű� 1��, 1�����̻� ���� 0.2��, 1�����̸� ���� 0.1��
  <br>   
  �� �������
  <br> 
  &nbsp;&nbsp;&nbsp;- ���ʿ����� : �Ʒ��� ��� ��ȿ������ �ش��ڿ��� �ְ� ���� �κ��� ���ʿ����ڿ� �ͼӵ�(��������� ���̳ʽ��� �Ǵ� ���� ����)
  <br> 
  &nbsp;&nbsp;&nbsp;- �����븮�� : 1�� ��������
  <br>
  &nbsp;&nbsp;&nbsp;- ��������� : �뿩������ 1�� �̻�� ���� ����,����,������ ���� ���
  <br> 
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� �Ϲݽ� : ��ȿ������ 1�� ��������ڿ� �ͼ�
  <br> 
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� �⺻�� : ��ȿ������ 0.5�� ��������ڿ� �ͼ�
  <br> 
  &nbsp;&nbsp;&nbsp;�� �뿩������ 1���̻�� ��ü�� ����,����,�����࿡�� �����븮���� �ִ� ���
  <br> 
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� �����븮�ΰ� ��������ڰ� �ٸ� ��� : ��ȿ������ �����븮�� 50%, ��������� 50%�� ������ �ͼӽ�Ų��.
  <br> 
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� �����븮�ΰ� ��������ڰ� ������ ��쿡�� 100% �����븮��(=���������)���� �ͼӵȴ�.
  <br> 
  &nbsp;&nbsp;&nbsp;- ����Ʈ : �ű԰���� ���ʿ����� ������ �Ǹ�, �������� ��������� ������ ��
  <br> 
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(�����븮���� �ִ� ��� ��ȿ������ ���ʿ����� 50%, �����븮�� 50%�� ������ �ͼӽ�Ų��.)
  <br>
  </font>    
</p>
</body>
</html>
