<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.util.*, acar.common.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String mode = request.getParameter("mode")==null?"0":request.getParameter("mode");
	
	String m_id = "";//��������ȣ
	String l_cd = "";//����ȣ
	String c_id = "";//�ڵ���������ȣ
	String accid_id = "";//��������ȣ
	
	String pay_dt = ""; //�Ա���
	String pay_amt = ""; //�Աݾ�
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	String due_dt = c_db.addDay(FineDocBn.getEnd_dt(), 1);
		
	//��ü����Ʈ
	Vector FineList = FineDocDb.getSettleDocLists(doc_id);
	
	String rent_st = "";
	int cls_per = 0;
	
	int start_dt = 0;	
	
	long amt3[]   = new long[9];
	
	int amt_1 = 0;
	int amt_2 = 0;
	int amt_3 = 0;
	int amt_4 = 0;
	int amt_5 = 0;
	int amt_6 = 0;
	int amt_7 = 0;
	long amt_i = 0;
	
	int	tot_amt = 0;
	int	tot_amt2 = 0;
	int	tot_amt3 = 0;
	
	//�μ⿩�� ����
	if(FineDocBn.getPrint_dt().equals("")){
		FineDocDb.changePrint_dt(doc_id, user_id);
	}
		
	int app_doc_h = 0;
	String app_doc_v = "";
					
	//���� ���μ�
	int tot_size =  FineList.size();
		
	int line_h = 32;
	//������ ����
	int page_h = 850;
	//�� ���̺� �⺻ ����
	int table1_h = 315+120;
	int table2_h = tot_size*line_h;	
	int table3_h = app_doc_h+140;
	
	//����������� ���ϱ�
	int page_cnt = ((table1_h+table2_h+table3_h)/page_h);
	if((table1_h+table2_h+table3_h)%page_h != 0) page_cnt = page_cnt + 1;
	
	//������ ���̺� ���� ���ϱ�
	int height = (page_h*page_cnt)-(table1_h+table2_h);	
	
	long t_amt1[] = new long[1];
    long t_amt2[] = new long[1];
    long t_amt3[] = new long[1];
    
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
		
	function onprint(){
		var userAgent = navigator.userAgent.toLowerCase();
		if (userAgent.indexOf("edge") > -1) {
			window.print();
		} else if (userAgent.indexOf("whale") > -1) {
			window.print();
		} else if (userAgent.indexOf("chrome") > -1) {
			window.print();
		} else if (userAgent.indexOf("firefox") > -1) {
			window.print();
		} else if (userAgent.indexOf("safari") > -1) {
			window.print();
		} else {
			IE_Print();
		}
		/* factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 20.0; //��������   
		factory.printing.rightMargin 	= 12.0; //��������
		factory.printing.topMargin 	= 20.0; //��ܿ���    
		factory.printing.bottomMargin 	= 20.0; //�ϴܿ���
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ�������� */
	}
	
function IE_Print() {
	factory1.printing.header = ""; //��������� �μ�
	factory1.printing.footer = ""; //�������ϴ� �μ�
	factory1.printing.portrait = true; //true-�����μ�, false-�����μ�    
 	factory1.printing.leftMargin = 20.0; //��������   
 	factory1.printing.rightMargin = 12.0; //��������
 	factory1.printing.topMargin = 20.0; //��ܿ���    
 	factory1.printing.bottomMargin = 20.0; //�ϴܿ���
	factory1.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}

function onprint(){
	
}
//-->
</script>
</head>
<body onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

<form action="" name="form1" method="POST" >
<div id="Layer1" style="position:absolute; left:565px; top:900px; width:109px; height:108px; z-index:1"><img src="/images/square.png" width="109" height="108"></div>
<table width='640' height="<%=table1_h%>" border="0" cellpadding="0" cellspacing="0">
	<tr>
    	<td height=10></td>
	</tR>
    <tr> 
        <td colspan="2" height="40" align="center" style="font-size : 20pt;"><b><u><font face="����">������ ���׺� �����ְ�</font></u></b></td>
    </tr>
    <tr> 
      <td colspan="2" height="50" align="center"></td>
    </tr>
  
    <tr> 
      <td height="125" colspan="2" align='center'> <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="10%" height="25" style="font-size : 10pt;"><font face="����">������ȣ</font></td>
            <td width="3%" height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            <td height="25" width="87%" style="font-size : 10pt;"><font face="����"><%=FineDocBn.getDoc_id()%> 
              </font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="����">�߽�����</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����"><%=AddUtil.getDate3(FineDocBn.getDoc_dt())%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="����">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����"><%=FineDocBn.getGov_nm()%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"></td>
            <td height="25" style="font-size : 10pt;"></td>
            <td height="25" style="font-size : 10pt;"><font face="����"><%=FineDocBn.getGov_addr()%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="����">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����">(��)�Ƹ���ī ��ǥ�̻� ������</font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="����"></font></td>
            <td height="25" style="font-size : 10pt;"><font face="����"></font></td>
            <td height="25" style="font-size : 10pt;"><font face="����">����� �������� �ǻ���� 8 ������� 8��</font></td>
          </tr>
        
        </table></td>
    </tr>
    <tr> 
      <td height="7" colspan="2" align='center'></td>
    </tr>
    <tr> 
      <td colspan=2 align='center' style="height:2; background-color:#999999"></td>
    </tr>
    <tr> 
      <td height="10" colspan="2" align='center'></td>
    </tr> 
	<tr>
	    <td height=10></td>
	</tR>
    <tr>
        <td align=center>
            <table width=628 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height="25" style="font-size : 10pt;"><p><font face="����">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. �ͻ��� ������ ������ ����մϴ�.</font></p>
                    <p>&nbsp;</p></td>
                </tr>
                <tr>
                   <td height="25" style="font-size : 10pt;"><p><font face="����">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. �����ϴٽ��� ���� ÷�ο� ���� �ͻ� ���谡���ڿ� ��� �����̿��ڰ��� ������� ������ ���� �߻��� �����Ḧ ÷�ο� ���� �ͻ翡 û���Ͽ����ϴ�.</font></p>
                   <p>&nbsp;</p></td>
                </tr>
                <tr>
                   <td height="25" style="font-size : 10pt;"><font face="����">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. �׷��� �ͻ翡 û���� ������ û���а� ���� �ͻ簡 �Ա��� �ݾװ��� ���̰� �־� �̸� �˷��帮��, �߻��� ���װ� ���ڸ� �ջ��� �ݾ׿� ���Ͽ� �Ʒ��� ���� �����Ͽ� �ֽ� ���� �ְ��մϴ�. (���ڴ� �Ϻαݾ��� �Ա��� ���κ��� �ְ��ϱ���, ���׿� ���� ��5%�� ������ ����Ͽ����ϴ�. ��, �Ϻαݾ׵� �Աݵ��� ���� ���� û������ ����Ϸ� �Ͽ� ���Ǿ����ϴ�.)</font></td>
                </tr>
                <tr>
                    <td>&nbsp;                  </td>
                </tr>
            	<tr>
                    <td height=10></td>
                </tR>
<% if(FineList.size()>0){
			for(int i=0; i<FineList.size(); i++){ 
				FineDocListBn = (FineDocListBean)FineList.elementAt(i); 
				if(FineDocListBn.getAmt5()==0){
					FineDocListBn.setAmt5(FineDocListBn.getAmt3());
				}
				amt_3 += FineDocListBn.getAmt5();

			}
		}%>	
                <tr>
                    <td>
                        <table width=628 border=0 cellspacing=1 cellpadding=0 bgcolor=000000>
                            <tr bgcolor=ffffff>
                                <td style="font-size : 9pt;" width=135 align=center bgcolor=ffffff height=40><font face="����">������ ���׺� �Ѱ� </font></td>
                                <td style="font-size : 9pt;" width=176 align=center bgcolor=ffffff>&nbsp;<span class=style12><font face="����"><%=Util.parseDecimal(amt_3)%>��</font></span></td>
                                <td style="font-size : 9pt;" width=135 align=center bgcolor=ffffff><span class=style10><font face="����">���α���</font></span></td>
                                <td style="font-size : 9pt;" width=177 align=center bgcolor=ffffff>&nbsp;<span class=style12><font face="����"><%=AddUtil.getDate3(FineDocBn.getEnd_dt())%></font></span></td>
                            </tr>
                            <tr bgcolor=#FFFFFF>
                                <td style="font-size : 9pt;" height=40 align=center bgcolor=ffffff><span class=style10><font face="����">�Աݰ��¹�ȣ</font></span></td>
                                <td style="font-size : 9pt;" bgcolor=#ffffff colspan=3 align='center'><span class=style12>&nbsp;<font face="����">���� 140-004-023863</font></span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=10></td>
                </tR>
                <tr>
                    <td height="25" style="font-size : 10pt;"><font face="����">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4. ���� �ͻ簡 ��� �����ϱ��� ������ ���׺��� �������� ���� ���, &nbsp;&nbsp;��翡 ���� �߻��� ����, �� ���� ���ظ� �������� �λ����� ���������� �����ϰ�, �̿� ������ ������� ���� û���� �����̿���, ÷�� ���ǰ� �����Ͽ� �߻��� ������ û���п� ���Ͽ� ��翡 ���� �����Ͽ� �ֽ� ���� ��� �帳�ϴ�. </font></td>
                </tr>
                <tr>
                    <td height=10></td>
                </tR>
                <tr>
                    <td height=10></td>
                </tR>
                 <tr>
                    <td height=10></td>
                </tR>
                <tr>
                    <td height=10></td>
                </tR>
                 <tr>
                    <td height=10></td>
                </tR>
                <tr>
                    <td height=10></td>
                </tR>
                 <tr>
                    <td height="25" style="font-size : 10pt;"><font face="����">&nbsp;&nbsp;�� ÷�� : ������ û������Ʈ �� 1 ��</font></td>
                </tr>
                <tr>
                    <td height=10></td>
                </tR>
                <tr>
                    <td height="25" style="font-size : 10pt;"><font face="����">&nbsp;&nbsp;�� ����ó : ������� ������ 02-6263-6383</font></td>
                </tr>
                <tr>
                    <td height=10></td>
                </tR>
             <tr>
                    <td height=10></td>
                </tR>
                <tr>
                    <td height=10></td>
                </tR>
                 <tr>
                    <td height=10></td>
                </tR>
                <tr>
                    <td height=10></td>
                </tR>
                </table>
		      </td>
        	</tr>
	    </td>
	</tr>
	<tr> 
      <td colspan="2"><font face="����">&nbsp;</font></td>
    </tr>
    <tr align="center"> 
      <td height="40" colspan="2" style="font-size : 19pt;"><font face="����"><b>�ֽ�ȸ�� 
        �Ƹ���ī ��ǥ�̻� ��&nbsp;&nbsp;��&nbsp;&nbsp;��</b></font></td>
    </tr>
    <tr>
        <td height=10></td>
    </tR>
    <tr>
        <td height=10></td>
    </tR>
</table>
					
<table width='695' height="" border="0" cellpadding="0" cellspacing="0">
	<tr> 
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ û������Ʈ</span></td>
    </tr>    
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
         <tr> 
            <td class='title' width="4%">����</td>
            <td class='title' width="9%">�������</td>
            <td class='title' width="9%">��������</td>
    	    <td class='title' width="8%">�����</td>
            <td class='title' width="9%">�������</td>
            <td class='title' width="9%">û������</td>						
            <td class='title' width="9%">û����</td>									
            <td class='title' width="9%">�Ա�����</td>												
            <td class='title' width="9%">�Աݾ�</td>
            <td class='title' width="9%">����</td>
            <td class='title' width="7%">����</td>
            <td class='title' width="9%">��</td>
            
          </tr>
  <% 	
			Vector vt = FineDocDb.getMyAccidDocLists_2(doc_id);
			int vt_size = vt.size();
			
            if(vt_size > 0){
				for(int i=0; i<vt.size(); i++){ 
					
					Hashtable ht = (Hashtable)vt.elementAt(i);					
					
					if(AddUtil.parseInt(String.valueOf(ht.get("AMT5")))==0){
						ht.put("AMT5", String.valueOf(ht.get("AMT3")));						
					}
					
					tot_amt += AddUtil.parseInt(String.valueOf(ht.get("AMT5")));
					
					tot_amt2 += AddUtil.parseInt(String.valueOf(ht.get("AMT3")));
					
					tot_amt3 += AddUtil.parseInt(String.valueOf(ht.get("AMT4")));
					
				
					%>		  
          <tr align="center"> 
            <td><%=i+1%></td>
            <td><%=ht.get("OUR_CAR_NO")%></td>			
            
            <td><%=ht.get("CAR_NO")%></td>			
            <td><%=ht.get("ACCID_ST")%></td>
            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ACCID_DT")))%></td>
            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT1"))%></td>
            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT2"))%></td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT3"))%></td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT4"))%></td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT5"))%></td>
          </tr>
          <% 	}
			} %>
			<tr>
				<td colspan="9" align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
				<td align='right'><%=Util.parseDecimal(tot_amt2)%></td>
				<td align='right'><%=Util.parseDecimal(tot_amt3)%></td>
				<td align='right'><%=Util.parseDecimal(tot_amt)%></td>
			</tr>
        </table>
      </td>
    </tr>
</table>

<table width='695' height="<%=table1_h%>" border="0" cellpadding="0" cellspacing="0">
  <% 	

	
		Vector vt2 = FineDocDb.getMyAccidDocLists_2(doc_id);
		int vt2_size = vt2.size();
        if(vt2_size > 0){
				for(int i=0; i<vt2.size(); i++){ 
					Hashtable ht2 = (Hashtable)vt2.elementAt(i);

				accid_id = String.valueOf(ht2.get("ACCID_ID"));
				m_id = String.valueOf(ht2.get("RENT_MNG_ID"));
				l_cd = String.valueOf(ht2.get("RENT_L_CD"));
				c_id = String.valueOf(ht2.get("CAR_MNG_ID"));				
				pay_dt = String.valueOf(ht2.get("RENT_END_DT"));
				pay_amt = String.valueOf(ht2.get("AMT2"));
			
					%>
	<tr>
		<td colspan=2>
		<% if ( i % 2 == 0 ) {%>
		<p style='page-break-before:always'><br style="height:0; line-height:0"></P>
		<% } %>
		<iframe src="accid_cb.jsp??auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&pay_dt=<%=pay_dt%>&pay_amt=<%=pay_amt%>&mode=8";" name="i_no" width="695" height="<%=table1_h%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>

		</td>
	</tr>
<% 	}
} %>						
</table>

</form>
</body>
</html>
