<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*"%>
<jsp:useBean id="st_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript' src='/include/estimate.js'></script>
<script language='javascript'>
<!--
	//���� ������ ����Ʈ �̵�
	function list_move(bus_id2)
	{
		var fm = document.form1;
		var url = "";
		fm.gubun1.value = '7';
		fm.gubun2.value = '2';
		fm.gubun3.value = '3';	
		fm.gubun4.value = '';			
		fm.s_kd.value = '8';		
		fm.t_wd.value = bus_id2;			
		url = "/acar/settle_acc/settle_s_frame.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
//-->
</script>
</head>


<body onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/smsx.cab#Version=6,3,439,30">
</object>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String search_kd = request.getParameter("search_kd")==null?"":request.getParameter("search_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String dept_id = request.getParameter("dept_id")==null?"0002":request.getParameter("dept_id");	
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
		//1�� ä�ǰ���ķ���� ����Ʈ
	Vector vt = st_db.getSettleBrList();
	int vt_size = vt.size();	
	
	float  tot_dly_amt = 0;
	float  dly_amt = 0;	

   for(int i=0; i < vt_size; i++){
       Hashtable ht = (Hashtable)vt.elementAt(i);
       
       tot_dly_amt += AddUtil.parseFloat(String.valueOf(ht.get("DLY_AMT")));		
	}
			
	String br_nm = "";
	

%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>

<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='gubun3' value=''>
<input type='hidden' name='gubun4' value='1'>
<input type='hidden' name='s_kd' value=''>
<input type='hidden' name='t_wd' value=''>
<input type='hidden' name='size2' value=''>
<input type='hidden' name='max_i' value=''>

<table width="900" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�濵���� > ķ���ΰ��� > <span class=style5>ä�ǰ���ķ����(�μ���)</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>

    <tr> 
        <td class="line">          
            <TABLE align=center border=0 width=100% cellspacing=1 cellpadding=0>
                 <tr>                     
                    <td width=6% rowspan="2" class="title">�μ�</td>									
                    <td width=10% colspan="2" class="title">��������</td>
                    <td width=8% rowspan="2" class="title">�ѹ�������</td>
                    <td width=10% rowspan="2" class="title">��ü�ݾ�</td>	
                    <td width=5% rowspan="2" class="title">��ü<br>������</td>																								
                    <td colspan="4" class="title">��ü��</td>
                    <td colspan="2" class="title">����ݾ�</td>                   
                </tr>
                <tr>
                  <td width=5% class="title">������</td>
                  <td width=5% class="title">����</td>
                  <td width=5% class="title">����</td>
                  <td width=6% class="title">���</td>
                  <td width=5% class="title">����</td>
                  <td width=5% class="title">����</td>
                  <td width=7% class="title">�����</td>
                  <td width=7% class="title">��Ʈ��</td>
                </tr>
			
         	<%	if(vt_size > 0){
					
						for (int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
													
						   dly_amt = AddUtil.parseFloat(String.valueOf(ht.get("DLY_AMT")));
							 
					 %>
									
          	<tr>              
                  <td align="center"><%=ht.get("BR_NM")%></td>			  
            
                  <td align="center"><%=ht.get("P1_CNT")%></td>                              
                  <td align="center"><%=ht.get("P2_CNT")%></td>
                  <td align="right"><%=Util.parseDecimalLong(String.valueOf(ht.get("TOT_AMT")))%></td>
                  <td align="right"><%=AddUtil.parseDecimal(dly_amt)%></td>	
                                             
                  <td align="right"><%=AddUtil.parseFloatCipher(Float.toString(dly_amt/tot_dly_amt*100), 3) %></td>			
					  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("PER1")), 3)%></td>	
                  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("AVG_PER")), 3)%></td>
                  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("CMP_PER")), 3)%></td>
                  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("R_CMP_PER")), 3)%></td>
                  <td align="right"></td>
                  <td align="right"></td>
         
                </tr>
              
				<%		}%>		       
					<%		}%>		            		
            </table>
        </td>
    </tr>
</table>
</form>
<script language='javascript'>
<!--

	function onprint(){
		factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 12.0; //��������   
		factory.printing.rightMargin 	= 12.0; //��������
		factory.printing.topMargin 	= 20.0; //��ܿ���    
		factory.printing.bottomMargin 	= 30.0; //�ϴܿ���
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
	}
	
//-->
</script>
</body>
</html>
