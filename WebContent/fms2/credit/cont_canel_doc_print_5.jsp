<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.util.*, acar.common.*,acar.cls.*, acar.forfeit_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");

	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	String due_dt = c_db.addDay(FineDocBn.getEnd_dt(), 0);
	String due_dt2 = c_db.addDay(FineDocBn.getEnd_dt(), 1);
		
	//��ü����Ʈ
	Vector FineList = FineDocDb.getSettleDocLists(doc_id);
	
	String rent_st = "";
	String cls_per = "";
	String cls_dt ="";
	
	int start_dt = 0;	
	
	int de_day = 0;
	
	int amt_5 = 0;

	
	
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
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function pagesetPrint(){
		IEPageSetupX.header='';
		IEPageSetupX.footer='';
		IEPageSetupX.leftMargin=12;
		IEPageSetupX.rightMargin=12;
		IEPageSetupX.topMargin=20;
		IEPageSetupX.bottomMargin=20;	
	<%if(FineDocBn.getPrint_dt().equals("")){%>
		print();
	<%}%>
	}
	
function IE_Print() {
	factory1.printing.header = ""; //��������� �μ�
	factory1.printing.footer = ""; //�������ϴ� �μ�
	factory1.printing.portrait = true; //true-�����μ�, false-�����μ�    
 	factory1.printing.leftMargin = 12.0; //��������   
 	factory1.printing.rightMargin = 12.0; //��������
 	factory1.printing.topMargin = 20.0; //��ܿ���    
 	factory1.printing.bottomMargin = 20.0; //�ϴܿ���
	factory1.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}

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
}
//-->
</script>
</head>
<body leftmargin="10" topmargin="1" onLoad="javascript:onprint();" >
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
</OBJECT> -->
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<form action="" name="form1" method="POST" >
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>

  <table width='640' height="<%=table1_h%>" border="0" cellpadding="0" cellspacing="0">
    <tr> 
        <td  height="40" colspan="2" align="center" style="font-size : 18pt;"><b><u><font face="����">��������� ���԰���</font></u></b></td>
    </tr>

 <!--  
     <tr> 
      <td colspan="2" height="1" align="center" bgcolor=000000></td>
    </tr>
 -->   
    
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
            <td height="25" style="font-size : 10pt;"><font face="����"><%=FineDocBn.getGov_nm()%>&nbsp;<%=FineDocBn.getMng_dept()%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"></td>
            <td height="25" style="font-size : 10pt;"></td>
            <td height="25" style="font-size : 10pt;"><font face="����"><%=FineDocBn.getGov_addr()%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="����">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����">(��)�Ƹ���ī</font></td>
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
    <tr bgcolor="#999999"> 
      <td colspan=2 align='center' height="2" bgcolor="#333333"></td>
    </tr>
    <tr> 
      <td height="10" colspan="2" align='center'></td>
    </tr>  
    <tr>
        <td align=center>
            <table width=628 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width="628" height="25" style="font-size : 10pt;"><p><font face="����">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. ���� �ͻ�(����)�� ������ �ŷ����谡 ���ӵǵ��� �ּ��� ����� ���ؿ�����, &nbsp;�� �� <b>��������� ���԰���</b>�� ������ �Ǿ����� ���������� �����մϴ�.</font></p>
                    </td>
                </tr>
				<tr>
                    <td height=10></td>
                </tr>
                <tr>
                   <td height="25" style="font-size : 10pt;"><font face="����">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. ���� �ͻ�(����)���� ���̿� ü���� �ڵ����뿩��� �ֿ䳻���� �Ʒ� ǥ�� �����ϴ�.</font></td>
                </tr>
                <tr>
                  <td>
                    <table width=628 border=0 cellspacing=1 cellpadding=0 bgcolor=000000>
                            <tr>
                                <td width=105  style="font-size : 9pt;" rowspan=2 align=center bgcolor=ffffff><span class=style10><font face="����">����</font></span></td>
                                <td width=96 style="font-size : 9pt;" rowspan=2 align=center bgcolor=ffffff><span class=style10><font face="����">������ȣ</font></span></td>
                                <td height=22 style="font-size : 9pt;" colspan=3 align=center bgcolor=ffffff><span class=style10><font face="����">�뿩�̿���Ⱓ</font></span></td>
                                <td width=75 style="font-size : 9pt;" rowspan=2 align=center bgcolor=ffffff><span class=style10><font face="����">������</font></span></td>
                                <td width=75 style="font-size : 9pt;" rowspan=2 align=center bgcolor=ffffff><span class=style10><font face="����">���ô뿩��</font></span></td>
                                <td width=72 style="font-size : 9pt;" rowspan=2 align=center bgcolor=ffffff><span class=style10><font face="����">���뿩��</font></span></td>
                            </tr>
                            <tr bgcolor=#FFFFFF>
                                <td width=75 style="font-size : 9pt;" height=22 align=center bgcolor=ffffff><span class=style10><font face="����">������</font></span></td>
                                <td width=75 style="font-size : 9pt;" align=center bgcolor=ffffff><span class=style10><font face="����">������</font></span></td>
                                <td width=52 style="font-size : 9pt;" align=center bgcolor=ffffff><span class=style10><font face="����">���</font></span></td>
                            </tr>
                            
<% if(FineList.size()>0){
			for(int i=0; i<FineList.size(); i++){ 
				FineDocListBn = (FineDocListBean)FineList.elementAt(i); 


				ClsBean cls = as_db.getClsCase(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd());
				
				de_day  =	AddUtil.parseInt((String)cls.getNfee_mon()) * 30  +   AddUtil.parseInt((String)cls.getNfee_day()); 

											
				//cont
				Hashtable base = a_db.getContViewCase(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd());
				
				rent_st = FineDocDb.getMaxRentSt(FineDocListBn.getRent_l_cd());
				
				ContFeeBean fee = a_db.getContFeeNew(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd(), rent_st);
				
				ContEtcBean cont_etc = a_db.getContEtc(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd());
				
//				cls_per = fee.getCls_per();
				cls_per = cls.getDft_int();
				cls_dt	= cls.getCls_dt();

				amt_5 += FineDocListBn.getAmt5();
	

%>	
                            <tr bgcolor=#FFFFFF>
                                <td style="font-size : 9pt;" height=25 align=center bgcolor=#FFFFFF><span class=style12><font face="����"><%=base.get("CAR_NM")%></font></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=#FFFFFF><span class=style11><font face="����"><%=base.get("CAR_NO")%></font></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=#FFFFFF><span class=style12><font face="����"><%=base.get("RENT_START_DT")%></font></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=#FFFFFF><span class=style12><font face="����"><%=base.get("RENT_END_DT")%></font></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=#FFFFFF><span class=style12><font face="����"><%=base.get("CON_MON")%>����</font></span></td>
                                <td style="font-size : 9pt;" align=right bgcolor=#FFFFFF><span class=style12><font face="����"><%=Util.parseDecimal(fee.getGrt_amt_s())%>&nbsp;</font></span></td>
                                <td style="font-size : 9pt;" align=right bgcolor=#FFFFFF><span class=style12><font face="����"><%=Util.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>&nbsp;</font></span></td>
                                <td style="font-size : 9pt;" align=right bgcolor=#FFFFFF><span class=style12><font face="����"><%=Util.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>&nbsp;</font></span></td>
                               
                            </tr>
<%
start_dt = AddUtil.ChangeStringInt(String.valueOf(base.get("RENT_START_DT")));
if(!cont_etc.getRent_suc_dt().equals("")){
	start_dt = AddUtil.parseInt(cont_etc.getRent_suc_dt());	
}
%>                             
<% 		}
} %>                                                    
                    </table>
                  </td>
                </tr>
              <tr>
                    <td height=10></td>
                </tr>
                <tr>
	                <td>
	                    <table width=628 border=0 cellspacing=1 cellpadding=0 bgcolor=000000>
	                        <tr bgcolor=ffffff>
	                            <td style="font-size : 9pt;" width=105 align=center bgcolor=ffffff height=25><span class=style10><font face="����">�ߵ���������</font></span></td>
	                            <td style="font-size : 9pt;" colspan=3 bgcolor=ffffff>&nbsp;<span class=style12><font face="����">���뿩�Ḧ 30�� �̻� ��ü�� �� ����� ���� �� �뿩���� ������ ȸ��</font></span></td>
	                        </tr>
	                        <tr bgcolor=#FFFFFF>
	                            <td style="font-size : 9pt;" height=25 align=center bgcolor=ffffff><span class=style10><font face="����">��ü������</font></span></td>
	                            <td style="font-size : 9pt;" align=center bgcolor=#FFFFFF width=214><span class=style12><font face="����"><%if(start_dt < 20081010 ) {%>�� 18%<%}else if(start_dt >= 20081010 && start_dt < 20220101) {%>�� 24%<%}else{%>�� 20%<%}%></font></span></td>
	                            <td style="font-size : 9pt;" align=center bgcolor=ffffff width=80><span class=style10><font face="����">�����</font></span></td>
	                            <td style="font-size : 9pt;" align=center bgcolor=#FFFFFF width=244><span class=style12><font face="����">�ܿ��Ⱓ �뿩�� �Ѿ��� (<%=cls_per%>)%</font></span></td>
	                        </tr>
                      </table>
	                </td>
	            </tr>
	             <tr>
	                <td height=10></td>
	            </tr>
                <tr>
	                 <td height="25" style="font-size : 10pt;"><font face="����">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. �ͻ�(����)�� ���������� �Ʒ� ǥ�� �����ϴ�. </font></td>
	            </tr>
                <tr>
                    <td>
                        <table width=628 border=0 cellspacing=1 cellpadding=0 bgcolor=000000>
                       
                            <tr bgcolor=#FFFFFF>
                                <td style="font-size : 9pt;" align=center bgcolor=ffffff colspan=2 height=25 width=157><span class=style10><font face="����"><b>����������</b></font></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=ffffff colspan=2 width=157>&nbsp;<span class=style12><font face="����"> <b><%=AddUtil.getDate3(cls_dt)%></b></font></span></td>
								 <td style="font-size : 9pt;" align=center bgcolor=ffffff colspan=2 height=25 width=157><span class=style10><font face="����"><b>���������</b></font></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=ffffff colspan=2 width=157>&nbsp;<span class=style12><font face="����"><b><%=Util.parseDecimal(amt_5)%>��</b></font></span></td>
                            </tr>
                      </table>
                    </td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td height="25" style="font-size : 10pt;"><font face="����">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4. �Ʒ� �Ͻñ��� ����������� �������� ���� ��� �ͻ�(����)���� ä��ȸ���� ���� ������ ��� å���� ���� ���Դϴ�. </font></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
				<tr>
                    <td>
                        <table width=628 border=0 cellpadding=0 cellspacing=1 bordercolor="#000000" bgcolor=000000>
                           <tr bgcolor=#ffffff>
                                <td style="font-size : 9pt;" align=center bgcolor=#ffffff height=25 width=157><span class=style10><font face="����"><b>��������ݳ��α���</b></font></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=#ffffff width=157>&nbsp;<span class=style12><font face="����"><b><%=AddUtil.getDate3(due_dt)%></b></font></span></td>
								<td style="font-size : 9pt;" align=center bgcolor=#ffffff height=25 width=157><span class=style10><font face="����"><b>ä��ȸ���������࿹����</b></font></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=#ffffff width=157>&nbsp;<span class=style12><font face="����"><b><%=AddUtil.getDate3(due_dt2)%></b></font></span></td>
                          </tr>
                          <tr bgcolor=#ffffff>
                                <td style="font-size : 9pt;" align=center bgcolor=#ffffff height=25 width=157><span class=style10><font face="����"><b>�Աݰ��¹�ȣ</b></font></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=#ffffff colspan=3><span class=style12>&nbsp;<font face="����"><b>���� 140-004-023871</b></font></span></td>
                          </tr>
                      </table>
                    </td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                     <td height="25" style="font-size : 10pt;"><font face="����">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5. ���� �� �Ͻñ��� ��������� ��ü�� �������� �ƴ��� ���, ���� �ͻ�( ���� )�� ���뺸������ ���� ��üä��(�ߵ��������������) ȸ�� �������� �߻��� �� �ִ� ��� ���(���з� �� ���� ��ŵ��� �Ҽ۰��� �����, ��Ÿ ������ ��ġ, ������Ź������ ����� ���� ����)�� &nbsp;���� û���� �����̸�, ��쿡 ���� �������� û�� �� �ſ���������� ä�� �߽��Ƿڿ� ä�������� ������ ����� ���̸�, ä�������� ���� ��� �� ���� �ſ� ���� �Ǵ� ����ſ����� �϶��ϰ� �ݸ��� ����ϴ� ���� �������� �߻� �� �� ������ �˷��帳�ϴ�.</font></td>
                </tr>
                <tr>
                    <td height=10></td>
                </tR>
                <tr>
                    <td height="25" style="font-size : 10pt;"><font face="����">&nbsp;&nbsp;<span class=style7>�� ����ó : ������� ������ 02-6263-6383</span></font></td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
			        <td align="center" height="25" style="font-size : 10pt;"><font face="����"><span class=style12>"�̹� �����ϼ̴ٸ� ������ ��� �帮��, �� �ȳ����� ����� �ֽñ� �ٶ��ϴ�."</span></font></td>
			    </tr>
               
                </table>
            </td>
        </tr>

    </td>
</tr>
</table>
<div style="position:relative">
<div id="Layer1" style="position:absolute; left:520px; top:0px; width:109px; height:108px; z-index:1"><img src="/images/square.png" width="109" height="108"></div>
<div style="position:relative; z-index:2;">
<table width='708' height="70" border="0" cellpadding="0" cellspacing="0">

    <tr> 
      <td width="708" colspan="2"><font face="����">&nbsp;</font></td>
    </tr>
    <tr align="center"> 
      <td height="40" colspan="2" style="font-size : 19pt;"><font face="����"><b>�ֽ�ȸ�� 
        �Ƹ���ī ��ǥ�̻� ��&nbsp;&nbsp;��&nbsp;&nbsp;��</b></font></td>
    </tr>
</table>
</div>
</div>
</form>
</body>
</html>