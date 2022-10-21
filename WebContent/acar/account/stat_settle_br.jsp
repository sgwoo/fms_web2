<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.settle_acc.*, acar.user_mng.*"%>
<jsp:useBean id="st_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "09", "05", "01");
		
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_settle");
		
	
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

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//���� ������ ����Ʈ �̵�
		
	//����Ʈ�ϱ�
	function cmp_print(){
		window.open("stat_settle_br_print.jsp?save_dt=<%=save_dt%>&auth_rw=<%=auth_rw%>","print","left=30,top=50,width=950,height=600,scrollbars=yes");	
	}
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
		
//-->
</script>
</head>

<body>

<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='from_page' value='/acar/account/stat_settle_201103_sc2.jsp'>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='gubun3' value=''>
<input type='hidden' name='gubun4' value='1'>
<input type='hidden' name='s_kd' value=''>
<input type='hidden' name='t_wd' value=''>


<div class="navigation">
	<span class=style1>�濵���� > ķ���ΰ��� ></span><span class=style5>ä��ķ����(�μ���) </span>
</div>



<table width="<%if(s_width.equals("768")){%><%=AddUtil.parseInt(s_width)-100%><%}else{%>100%<%}%>" border="0" cellspacing="0" cellpadding="0">
	
	<tr> 
        <td align="right"><img src=../images/center/arrow_gji.gif border=0 align=absmiddle> : <%=AddUtil.ChangeDate2(save_dt)%></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
  
    <tr> 
        <td class="line"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
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
   
    <tr> 
       <td  align="right">
		  <%if(nm_db.getWorkAuthUser("������",user_id)){%>
	      &nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:cmp_print()' title='����Ʈ�ϱ�'><img src=../images/center/button_print.gif align=absmiddle border=0></a>
		  <%}%>
        </td>				
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
</table>
</form>
<script language='javascript'>
<!--


//-->
</script>
</body>
</html>

