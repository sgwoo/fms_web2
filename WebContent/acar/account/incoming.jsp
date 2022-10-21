<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.account.AccountDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������

	String search_kd = request.getParameter("search_kd")==null?"":request.getParameter("search_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");

	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
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

	//���� ������ ����Ʈ �̵�
	function list_move(gubun1, gubun2, gubun3)
	{
		var fm = document.form1;
		var url = "";
		fm.gubun1.value = gubun1;
		fm.gubun2.value = gubun2;
		fm.gubun3.value = gubun3;	
		var idx = gubun1;
		if(idx == '1') 		url = "/fms2/con_fee/fee_frame_s.jsp";
		else if(idx == '2'){
			url = "/fms2/con_grt/grt_frame_s.jsp";
			fm.gubun4.value = '';	
		}
		else if(idx == '3') url = "/acar/con_forfeit/forfeit_frame_s.jsp";
		else if(idx == '4') url = "/fms2/con_ins_m/ins_m_frame_s.jsp";
		else if(idx == '5') url = "/acar/con_ins_h/ins_h_frame_s.jsp";
		else if(idx == '6') url = "/fms2/con_cls/cls_frame_s.jsp";		
		else if(idx == '7') url = "/acar/settle_acc/settle_s_frame.jsp";		
		else if(idx == '8') url = "/fms2/con_s_rent/con_s_rent2_frame.jsp";		
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
//-->
</script>
</head>

<body leftmargin=15>

<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > <span class=style5>������Ȳ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
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
                    <td rowspan="2" colspan="3" width="16%" class='title' align="center">����</td>
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
          <%	//�뿩�� ��Ȳ
	Vector fees = ac_db.getFeeStat(br_id, search_kd, brch_id, bus_id2);
	int fee_size = fees.size();
	IncomingSBean fee1 = new IncomingSBean();
	IncomingSBean fee2 = new IncomingSBean();
	IncomingSBean fee3 = new IncomingSBean();
	IncomingSBean fee4 = new IncomingSBean();
	if(fee_size > 0){
		for (int i = 0 ; i < 4 ; i++){
			IncomingSBean fee = (IncomingSBean)fees.elementAt(i);
			if(i==1) fee1 = fee; //����
			if(i==2) fee2 = fee; //�̼���
			if(i==3) fee3 = fee; //����			
			%>
                <tr> 
                    <%if(i==1){%>
                    <td width="3%" rowspan="4" align="center" class='title'>û��</td>                    
                    <td width="3%" rowspan="3" align="center" class='title'>����</td>
                    <%}%>                
                    <td <%if(i==0){%>colspan="3"<%}%> align="center" class='title'><%=fee.getGubun()%></td>
                    <td align="right"> 
                      <%if(fee.getGubun().equals("������")){%>                      
                      <%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(fee1.getTot_su1()))/AddUtil.parseFloat(String.valueOf(AddUtil.parseLong(fee1.getTot_su1())+AddUtil.parseLong(fee2.getTot_su1())))*100,2)%>%
                      <% }else{%>
                      <a href="javascript:list_move('1', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fee.getTot_su1()%>��</a> 
                      <%}%>
                      </td>
                    <td align="right"> 
                      <%if(fee.getGubun().equals("������")){%>                      
                      <%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(fee1.getTot_amt1()))/AddUtil.parseFloat(String.valueOf(AddUtil.parseLong(fee1.getTot_amt1())+AddUtil.parseLong(fee2.getTot_amt1())))*100,2)%>%                      
                      <%}else{%>
                      <%=AddUtil.parseDecimal2(fee.getTot_amt1())%>�� 
                      <%}%>
                      </td>
                    <td align="right"> 
                      <%if(fee.getGubun().equals("������")){%>
                      <%=fee.getTot_su2()%>% 
                      <% }else{%>
                      <a href="javascript:list_move('1', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fee.getTot_su2()%>��</a> 
                      <%}%>
                      </td>
                    <td align="right"> 
                      <%if(fee.getGubun().equals("������")){%>
                      <%=fee.getTot_amt2()%>% 
                      <%}else{%>
                      <%=AddUtil.parseDecimal2(fee.getTot_amt2())%>�� 
                      <%}%>
                      </td>
                    <td align="right"> 
                      <%if(fee.getGubun().equals("������")){%>
                      <%=fee.getTot_su3()%>% 
                      <% }else{%>
                      <a href="javascript:list_move('1', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fee.getTot_su3()%>��</a> 
                      <%}%>
                      </td>
                    <td align="right"> 
                      <%if(fee.getGubun().equals("������")){%>
                      <%=fee.getTot_amt3()%>% 
                      <%}else{%>
                      <%=AddUtil.parseDecimal2(fee.getTot_amt3())%>�� 
                      <%}%>
                      </td>
                    <td align="right"> 
                      <%if(fee.getGubun().equals("������")){%>
                      - 
                      <%}else{%>
                      <a href="javascript:list_move('1', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=AddUtil.parseInt(fee.getTot_su2())+AddUtil.parseInt(fee.getTot_su3())%>��</a> 
                      <%}%>
                      </td>
                    <td align="right"> 
                      <%if(!fee.getGubun().equals("������")){%>
                      <%=AddUtil.parseDecimalLong(String.valueOf(AddUtil.parseLong(fee.getTot_amt2())+AddUtil.parseLong(fee.getTot_amt3())))%>�� 
                      <%}else{%>
                      -&nbsp; 
                      <%}%>
                      </td>
                  </tr>
                  <%		}%>                  
                  <%	fee4 = (IncomingSBean)fees.elementAt(4);%>
                <tr> 
                    <td colspan="2" align="center" class='title'>����</td>
                    <td align="right"><a href="javascript:list_move('1', '1', '<%=4+1%>');" onMouseOver="window.status=''; return true"><%=fee4.getTot_su1()%>��</a> </td>
                    <td align="right"><%=AddUtil.parseDecimal2(fee4.getTot_amt1())%>�� </td>
                    <td colspan="4" class='title'>&nbsp;</td>
                    <td align="right">-</td>
                    <td align="right">-</td>
                </tr>                       
                <tr> 
                    <td colspan="3" align="center" class='title'>��ȹ��������</td>
                    <td align="right"><%=fee3.getTot_su1()%>%</td>
                    <td align="right"><%=fee3.getTot_amt1()%>%</td>
                    <td align="right"><%=fee3.getTot_su2()%>%</td>
                    <td align="right"><%=fee3.getTot_amt2()%>%</td>
                    <td align="right"><%=fee3.getTot_su3()%>%</td>
                    <td align="right"><%=fee3.getTot_amt3()%>%</td>
                    <td align="right">-</td>
                    <td align="right">-</td>
                </tr>		                           
        	<%}else{%>
                  <tr> 
                    <td colspan="11" align="center">�ڷᰡ �����ϴ�.</td>
                  </tr>
                  <%	}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>    
    <tr> 
        <td class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
        <%	//�뿩�� ��Ȳ - ��ü��
        	Vector feedps = ac_db.getFeeStat_Dlyper(br_id, search_kd, brch_id, bus_id2);
        	int feedp_size = feedps.size();
        	if(feedp_size > 0){
        		for (int i = 0 ; i < feedp_size ; i++){
        			IncomingSBean feedp = (IncomingSBean)feedps.elementAt(i);%>		  
                <tr> 
                    <td width="16%" class='title'>�����뿩�� �Ѱ�</td>
                    <td width=21% align="right"><b><%=AddUtil.parseDecimalLong(feedp.getTot_amt1())%>��</b>&nbsp;</td>
                    <td width=21% class='title'>��ü�뿩��</td>
                    <td width=21%" align="right"><b><font color='red'><%=AddUtil.parseDecimalLong(feedp.getTot_amt2())%>��</font></b>&nbsp;</td>
                    <td width=9% class='title'>��ü��</td>
                    <td width=12%  align="center"><b><font color='red'><%=feedp.getTot_su1()%>%</font></b>&nbsp;</td>
                </tr>
        <%		}
        	}%>		  
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
<%	//������ ��Ȳ
	Vector pres = ac_db.getPreStat2(br_id, search_kd, brch_id, bus_id2);
	int pre_size = pres.size();
	if(pre_size > 0){//10 rows
		for (int i = 0 ; i < pre_size ; i++){
			IncomingSBean pre = (IncomingSBean)pres.elementAt(i);%>
                <tr> 
            <%	if(!pre.getGubun_sub().equals("N")){
					if(i%5 == 0){%>
                    <td align="center" class='title' rowspan="4"><%=pre.getGubun()%></td>
                    <td align="center" class='title'><%=pre.getGubun_sub()%></td>
                    <%		}else{%>
                    <td align="center" class='title'><%=pre.getGubun_sub()%></td>
                    <%		}
        			  	}else{%>
                    <td align="center" class='title' colspan="2"><%=pre.getGubun()%></td>
                    <%	}%>
                    <td align="right"  <%if(pre.getGubun().equals("�Ұ�")){%>class='is'<%}%>><%if(pre.getGubun().equals("������")){%><%=pre.getTot_su1()%>%<% }else{ if(pre.getGubun().equals("�Ұ�")){%><a href="javascript:list_move('2', '1', '<%=(i+1)/4%>');" onMouseOver="window.status=''; return true"><%=pre.getTot_su1()%>��</a><%}else{%><%=pre.getTot_su1()%>��<%}}%>&nbsp;</td>
                    <td align="right" <%if(pre.getGubun().equals("�Ұ�")){%>class='is'<%}%>><%if(pre.getGubun().equals("������")){%><%=pre.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(pre.getTot_amt1())%>��<%}%> &nbsp;</td>
                    <td align="right"  <%if(pre.getGubun().equals("�Ұ�")){%>class='is'<%}%>><%if(pre.getGubun().equals("������")){%><%=pre.getTot_su2()%>%<% }else{ if(pre.getGubun().equals("�Ұ�")){%><a href="javascript:list_move('2', '2', '<%=(i+1)/4%>');" onMouseOver="window.status=''; return true"><%=pre.getTot_su2()%>��</a><%}else{%><%=pre.getTot_su2()%>��<%}}%>&nbsp;</td>
                    <td align="right" <%if(pre.getGubun().equals("�Ұ�")){%>class='is'<%}%>><%if(pre.getGubun().equals("������")){%><%=pre.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(pre.getTot_amt2())%>��<%}%>&nbsp;</td>
                    <td align="right"  <%if(pre.getGubun().equals("�Ұ�")){%>class='is'<%}%>><%if(pre.getGubun().equals("������")){%><%=pre.getTot_su3()%>%<% }else{ if(pre.getGubun().equals("�Ұ�")){%><a href="javascript:list_move('2', '3', '<%=(i+1)/4%>');" onMouseOver="window.status=''; return true"><%=pre.getTot_su3()%>��</a><%}else{%><%=pre.getTot_su3()%>��<%}}%>&nbsp;</td>
                    <td align="right" <%if(pre.getGubun().equals("�Ұ�")){%>class='is'<%}%>><%if(pre.getGubun().equals("������")){%><%=pre.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(pre.getTot_amt3())%>��<%}%>&nbsp;</td>
                    <td align="right"  <%if(pre.getGubun().equals("�Ұ�")){%>class='is'<%}%>>
        			  <%if(!pre.getGubun().equals("������") && pre.getGubun().equals("�Ұ�")){%><a href="javascript:list_move('2', '6', '<%=(i+1)/4%>');" onMouseOver="window.status=''; return true"><%=AddUtil.parseInt(pre.getTot_su2())+AddUtil.parseInt(pre.getTot_su3())%>��</a><%}else{%>-<%}%>&nbsp;
        			<td align="right" <%if(pre.getGubun().equals("�Ұ�")){%>class='is'<%}%>>
                      <%if(!pre.getGubun().equals("������")){%><%=Util.parseDecimal(String.valueOf(AddUtil.parseInt(pre.getTot_amt2())+AddUtil.parseInt(pre.getTot_amt3())))%>��<%}else{%>-&nbsp;<%}%>&nbsp;</td>
                </tr>
<%		}
	}else{%>
                <tr> 
                    <td colspan="10" align="center">�ڷᰡ �����ϴ�.</td>
                </tr>
<%	}%>
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
                    <td colspan="2" rowspan="2" width="16%" class='title'>����</td>
                    <td colspan="2" width="21%" class='title'>���</td>
                    <td colspan="2" width="21%" class='title'>����</td>
                    <td colspan="2" width="21%" class='title'>��ü</td>
                    <td colspan="2" width="21%" class='title'>�հ�(����+��ü)</td>
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
<%	//����Ʈ ��Ȳ
	Vector fees2 = ac_db.getFeeRmStat(br_id, search_kd, brch_id, bus_id2);
	int fee_size2 = fees2.size();
	if(fee_size2 > 0){
		for (int i = 0 ; i < fee_size2 ; i++){
			IncomingSBean fee = (IncomingSBean)fees2.elementAt(i);%>		
			
                <tr> 
                    <%if(i==0){%>
                    <td width="6%" rowspan="4" align="center" class='title'>����Ʈ</td>
                    <%}%>
                    <td width="10%" align="center" class='title'><%=fee.getGubun()%></td>
                    <td align="right"><%if(fee.getGubun().equals("������")){%><%=fee.getTot_su1()%>%<% }else{%><a href="javascript:list_move('1', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fee.getTot_su1()%>��</a><%}%>&nbsp;</td>
                    <td align="right"><%if(fee.getGubun().equals("������")){%><%=fee.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(fee.getTot_amt1())%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(fee.getGubun().equals("������")){%><%=fee.getTot_su2()%>%<% }else{%><a href="javascript:list_move('1', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fee.getTot_su2()%>��</a><%}%>&nbsp;</td>
                    <td align="right"><%if(fee.getGubun().equals("������")){%><%=fee.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(fee.getTot_amt2())%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(fee.getGubun().equals("������")){%><%=fee.getTot_su3()%>%<% }else{%><a href="javascript:list_move('1', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fee.getTot_su3()%>��</a><%}%>&nbsp;</td>
                    <td align="right"><%if(fee.getGubun().equals("������")){%><%=fee.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(fee.getTot_amt3())%>��<%}%>&nbsp;</td>
                    <td align="right"> 
                      <%if(!fee.getGubun().equals("������")){%><a href="javascript:list_move('1', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=AddUtil.parseInt(fee.getTot_su2())+AddUtil.parseInt(fee.getTot_su3())%>��</a><%}else{%>-&nbsp;<%}%>&nbsp;</td>  
        			<td align="right">
                      <%if(!fee.getGubun().equals("������")){%><%=Util.parseDecimal(String.valueOf(AddUtil.parseInt(fee.getTot_amt2())+AddUtil.parseInt(fee.getTot_amt3())))%>��<%}else{%>-&nbsp;<%}%>&nbsp;</td>
                </tr>
        <%		}
        	}else{%>		
        		<tr>
        			<td colspan="10" align="center">�ڷᰡ �����ϴ�.</td>
        		</tr>
<%	}%>	        
  
<%	//������� ��Ȳ
	Vector ins_sr2 = ac_db.getCarSRent2Stat(br_id, search_kd, brch_id, bus_id2);
	int ins_sr2_size = ins_sr2.size();
	if(ins_sr2_size > 0){
		for (int i = 0 ; i < ins_sr2_size ; i++){
			IncomingSBean ins_h = (IncomingSBean)ins_sr2.elementAt(i);%>		
			
                <tr> 
                    <%if(i==0){%>
                    <td width="6%" rowspan="4" align="center" class='title'>�������</td>
                    <%}%>
                    <td width="10%" align="center" class='title'><%=ins_h.getGubun()%></td>
                    <td align="right"><%if(ins_h.getGubun().equals("������")){%><%=ins_h.getTot_su1()%>%<% }else{%><a href="javascript:list_move('8', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins_h.getTot_su1()%>��</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("������")){%><%=ins_h.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(ins_h.getTot_amt1())%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("������")){%><%=ins_h.getTot_su2()%>%<% }else{%><a href="javascript:list_move('8', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins_h.getTot_su2()%>��</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("������")){%><%=ins_h.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(ins_h.getTot_amt2())%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("������")){%><%=ins_h.getTot_su3()%>%<% }else{%><a href="javascript:list_move('8', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins_h.getTot_su3()%>��</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("������")){%><%=ins_h.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(ins_h.getTot_amt3())%>��<%}%>&nbsp;</td>
                    <td align="right"> 
                      <%if(!ins_h.getGubun().equals("������")){%><a href="javascript:list_move('8', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=AddUtil.parseInt(ins_h.getTot_su2())+AddUtil.parseInt(ins_h.getTot_su3())%>��</a><%}else{%>-&nbsp;<%}%>&nbsp;</td>  
        			<td align="right">
                      <%if(!ins_h.getGubun().equals("������")){%><%=Util.parseDecimal(String.valueOf(AddUtil.parseInt(ins_h.getTot_amt2())+AddUtil.parseInt(ins_h.getTot_amt3())))%>��<%}else{%>-&nbsp;<%}%>&nbsp;</td>
                </tr>
        <%		}
        	}else{%>		
        		<tr>
        			<td colspan="10" align="center">�ڷᰡ �����ϴ�.</td>
        		</tr>
<%	}%>	
        
<%	//��/������ ��Ȳ
	Vector ins_hs = ac_db.getInsHStat(br_id, search_kd, brch_id, bus_id2);
	int ins_h_size = ins_hs.size();
	if(ins_h_size > 0){
		for (int i = 0 ; i < ins_h_size ; i++){
			IncomingSBean ins_h = (IncomingSBean)ins_hs.elementAt(i);%>		
			
                <tr> 
                    <%if(i==0){%>
                    <td width="6%" rowspan="4" align="center" class='title'>������</td>
                    <%}%>
                    <td width="10%" align="center" class='title'><%=ins_h.getGubun()%></td>
                    <td align="right"><%if(ins_h.getGubun().equals("������")){%><%=ins_h.getTot_su1()%>%<% }else{%><a href="javascript:list_move('5', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins_h.getTot_su1()%>��</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("������")){%><%=ins_h.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(ins_h.getTot_amt1())%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("������")){%><%=ins_h.getTot_su2()%>%<% }else{%><a href="javascript:list_move('5', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins_h.getTot_su2()%>��</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("������")){%><%=ins_h.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(ins_h.getTot_amt2())%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("������")){%><%=ins_h.getTot_su3()%>%<% }else{%><a href="javascript:list_move('5', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins_h.getTot_su3()%>��</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins_h.getGubun().equals("������")){%><%=ins_h.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(ins_h.getTot_amt3())%>��<%}%>&nbsp;</td>
                    <td align="right"> 
                      <%if(!ins_h.getGubun().equals("������")){%><a href="javascript:list_move('5', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=AddUtil.parseInt(ins_h.getTot_su2())+AddUtil.parseInt(ins_h.getTot_su3())%>��</a><%}else{%>-&nbsp;<%}%>&nbsp;</td>  
        			<td align="right">
                      <%if(!ins_h.getGubun().equals("������")){%><%=Util.parseDecimal(String.valueOf(AddUtil.parseInt(ins_h.getTot_amt2())+AddUtil.parseInt(ins_h.getTot_amt3())))%>��<%}else{%>-&nbsp;<%}%>&nbsp;</td>
                </tr>
        <%		}
        	}else{%>		
        		<tr>
        			<td colspan="10" align="center">�ڷᰡ �����ϴ�.</td>
        		</tr>
<%	}%>	
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
                    <td colspan="2" rowspan="2" width="16%"  class='title'>����</td>
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
<%	//�ߵ���������� ��Ȳ
	Vector clss = ac_db.getClsStat2(br_id, search_kd, brch_id, bus_id2);
	int cls_size = clss.size();
	if(cls_size > 0){
		for (int i = 0 ; i < cls_size ; i++){
			IncomingSBean cls = (IncomingSBean)clss.elementAt(i);%>		
                <tr> 
                    <%if(i==0){%>
                    <td width="6%" rowspan="4" align="center" class='title'>��������</td>
                    <%}%>
                    <td width="10%" align="center" class='title'><%=cls.getGubun()%></td>
                    <td align="right"><%if(cls.getGubun().equals("������")){%><%=cls.getTot_su1()%>%<% }else{%><a href="javascript:list_move('6', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=cls.getTot_su1()%>��</a><%}%>&nbsp;</td>
                    <td align="right"><%if(cls.getGubun().equals("������")){%><%=cls.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(cls.getTot_amt1())%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(cls.getGubun().equals("������")){%><%=cls.getTot_su2()%>%<% }else{%><a href="javascript:list_move('6', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=cls.getTot_su2()%>��</a><%}%>&nbsp;</td>
                    <td align="right"><%if(cls.getGubun().equals("������")){%><%=cls.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(cls.getTot_amt2())%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(cls.getGubun().equals("������")){%><%=cls.getTot_su3()%>%<% }else{%><a href="javascript:list_move('6', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=cls.getTot_su3()%>��</a><%}%>&nbsp;</td>
                    <td align="right"><%if(cls.getGubun().equals("������")){%><%=cls.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(cls.getTot_amt3())%>��<%}%>&nbsp;</td>
                    <td align="right"> 
                      <%if(!cls.getGubun().equals("������")){%><a href="javascript:list_move('6', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=AddUtil.parseInt(cls.getTot_su2())+AddUtil.parseInt(cls.getTot_su3())%>��</a><%}else{%>-&nbsp;<%}%>&nbsp;</td>  
        			<td align="right">
                      <%if(!cls.getGubun().equals("������")){%><%=Util.parseDecimal(String.valueOf(AddUtil.parseInt(cls.getTot_amt2())+AddUtil.parseInt(cls.getTot_amt3())))%>��<%}else{%>-&nbsp;<%}%>&nbsp;</td>
                </tr>
        <%		}
        	}else{%>		
        		<tr>
        			<td colspan="9" align="center">�ڷᰡ �����ϴ�.</td>
        		</tr>
<%	}%>	
                
<%	//���·� ��Ȳ
	Vector fines = ac_db.getFineStat(br_id, search_kd, brch_id, bus_id2);
	int fine_size = fines.size();
	if(fine_size > 0){
		for (int i = 0 ; i < fine_size ; i++){
			IncomingSBean fine = (IncomingSBean)fines.elementAt(i);%>		
                <tr> 
                    <%if(i==0){%>
                    <td width="6%" rowspan="4" align="center" class='title'>���·�</td>
                    <%}%>
                    <td width="10%" align="center" class='title'><%=fine.getGubun()%></td>		
                    <td align="right"><%if(fine.getGubun().equals("������")){%><%=fine.getTot_su1()%>%<% }else{%><a href="javascript:list_move('3', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fine.getTot_su1()%>��</a><%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getGubun().equals("������")){%><%=fine.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(fine.getTot_amt1())%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getGubun().equals("������")){%><%=fine.getTot_su2()%>%<% }else{%><a href="javascript:list_move('3', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fine.getTot_su2()%>��</a><%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getGubun().equals("������")){%><%=fine.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(fine.getTot_amt2())%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getGubun().equals("������")){%><%=fine.getTot_su3()%>%<% }else{%><a href="javascript:list_move('3', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=fine.getTot_su3()%>��</a><%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getGubun().equals("������")){%><%=fine.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(fine.getTot_amt3())%>��<%}%>&nbsp;</td>
                    <td align="right"> 
                      <%if(!fine.getGubun().equals("������")){%><a href="javascript:list_move('3', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=AddUtil.parseInt(fine.getTot_su2())+AddUtil.parseInt(fine.getTot_su3())%>��</a><%}else{%>-&nbsp;<%}%>&nbsp;</td>  
        			<td align="right">
                    <%if(!fine.getGubun().equals("������")){%><%=Util.parseDecimal(String.valueOf(AddUtil.parseInt(fine.getTot_amt2())+AddUtil.parseInt(fine.getTot_amt3())))%>��<%}else{%>-&nbsp;<%}%>&nbsp;</td>
                </tr>
<%		}
	}else{%>		
		        <tr>
			        <td colspan="10" align="center">�ڷᰡ �����ϴ�.</td>
		        </tr>
<%	}%>

<%	//��å�� ��Ȳ
	Vector ins_ms = ac_db.getInsMStat(br_id, search_kd, brch_id, bus_id2);
	int ins_m_size = ins_ms.size();
	if(ins_m_size > 0){
		for (int i = 0 ; i < ins_m_size ; i++){
			IncomingSBean ins_m = (IncomingSBean)ins_ms.elementAt(i);%>		
                <tr> 
                    <%if(i==0){%>
                    <td width="6%" rowspan="4" align="center" class='title'>��å��</td>
                    <%}%>
                    <td align="center" class='title'><%=ins_m.getGubun()%></td>
                    <td width="10%" align="right"><%if(ins_m.getGubun().equals("������")){%><%=ins_m.getTot_su1()%>%<% }else{%><a href="javascript:list_move('4', '1', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins_m.getTot_su1()%>��</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins_m.getGubun().equals("������")){%><%=ins_m.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(ins_m.getTot_amt1())%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(ins_m.getGubun().equals("������")){%><%=ins_m.getTot_su2()%>%<% }else{%><a href="javascript:list_move('4', '2', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins_m.getTot_su2()%>��</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins_m.getGubun().equals("������")){%><%=ins_m.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(ins_m.getTot_amt2())%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(ins_m.getGubun().equals("������")){%><%=ins_m.getTot_su3()%>%<% }else{%><a href="javascript:list_move('4', '3', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=ins_m.getTot_su3()%>��</a><%}%>&nbsp;</td>
                    <td align="right"><%if(ins_m.getGubun().equals("������")){%><%=ins_m.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(ins_m.getTot_amt3())%>��<%}%>&nbsp;</td>
                    <td align="right"> 
                      <%if(!ins_m.getGubun().equals("������")){%><a href="javascript:list_move('4', '6', '<%=i+1%>');" onMouseOver="window.status=''; return true"><%=AddUtil.parseInt(ins_m.getTot_su2())+AddUtil.parseInt(ins_m.getTot_su3())%>��</a><%}else{%>-&nbsp;<%}%>&nbsp;</td>  
        			<td align="right">
                      <%if(!ins_m.getGubun().equals("������")){%><%=Util.parseDecimal(String.valueOf(AddUtil.parseInt(ins_m.getTot_amt2())+AddUtil.parseInt(ins_m.getTot_amt3())))%>��<%}else{%>-&nbsp;<%}%>&nbsp;</td>
                </tr>
        <%		}
        	}else{%>		
        		<tr>
        			<td colspan="9" align="center">�ڷᰡ �����ϴ�.</td>
        		</tr>
<%	}%>	
	
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
