<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cost.*"%>

<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1"); //�⵵
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2"); //�׸�
		
	// gubun2 : 1:ä�� 	
	Vector vt = ac_db.getStatCmpList2(gubun1, gubun2);
		
	int vt_size =vt.size();
	
	float t_amt1[] = new float[2];   
    float t_amt2[] = new float[2];   
    float t_amt3[] = new float[2];   
    float t_amt4[] = new float[2];   
    float t_amt5[] = new float[2];   
   	float ave_per[] = new float[2];   
    
      
    float ct_amt1[] = new float[2];
    float ct_amt2[] = new float[2];  
    float ct_amt3[] = new float[2];  
    float ct_amt4[] = new float[2];  
    
    String loan_chk = "";
    int    loan_cnt = 1;
    int    t_loan_cnt = 1;
    
    int tp_amt0 = 0;
    int tp_amt1 = 0;
    int tp_amt2 = 0;
    int tp_amt3 = 0;      
    
    String dept_nm = "";
    
    //������ ��������  - 
    String  vt_dt[]	 	= new String[4];
 
    Vector vt1 = ac_db.getSaveDt(gubun1, gubun2);
     
    for(int i = 0 ; i < vt1.size() ; i++){
		Hashtable ht = (Hashtable)vt1.elementAt(i);
	
		if ( i == 0 ) vt_dt[0]=	String.valueOf(ht.get("SAVE_DT"));
		if ( i == 1 ) vt_dt[1]=	String.valueOf(ht.get("SAVE_DT"));
		if ( i == 2 ) vt_dt[2]=	String.valueOf(ht.get("SAVE_DT"));		
		if ( i == 3 ) vt_dt[3]=	String.valueOf(ht.get("SAVE_DT"));		
	}    
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!-- 
 //��������Ÿ�� ���� - ���Ұ� - 20200116
function viewCamaign(gubun1, gubun2)
{
	//����
		window.open("/acar/account/stat_settle_201103_sc2.jsp?save_dt="+gubun1, "viewCamaign", "left=100, top=20, width=1000, height=900, scrollbars=auto");
	
}
//-->
</script>
<script language='javascript'>

</script>
</head>
<body>

<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>		
        <td class=line>	
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td rowspan=2 width="2%" class='title' >����</td>
                    <td rowspan=2 width="10%" class='title' >����</td>
                    <td rowspan=2 width="7%" class='title'>����</td>
                    <td rowspan=2 width="7%" class='title'>�Ի���</td>             
        	        <td colspan=3 class=title>1
        	     <!--     <a href="javascript:viewCamaign('<%=vt_dt[0]%>', '����')" onMouseOver="window.status=''; return true" hover><img src="http://fms1.amazoncar.co.kr/acar/images/center/icon_memo.gif"  align="absmiddle" border="0"></a>&nbsp;       -->            
        	        </td>
                    <td colspan=3 class=title>2
				<!--  <a href="javascript:viewCamaign('<%=vt_dt[1]%>', '����')" onMouseOver="window.status=''; return true" hover><img src="http://fms1.amazoncar.co.kr/acar/images/center/icon_memo.gif"  align="absmiddle" border="0"></a>&nbsp;   -->                
        	        </td>
                    <td colspan=3 class=title>3
 				<!-- 	 <a href="javascript:viewCamaign('<%=vt_dt[2]%>', '����')" onMouseOver="window.status=''; return true" hover><img src="http://fms1.amazoncar.co.kr/acar/images/center/icon_memo.gif"  align="absmiddle" border="0"></a>&nbsp;  -->                 
        	        </td>
                    <td colspan=3 class=title>4
				<!-- 	 <a href="javascript:viewCamaign('<%=vt_dt[3]%>', '����')" onMouseOver="window.status=''; return true" hover><img src="http://fms1.amazoncar.co.kr/acar/images/center/icon_memo.gif"  align="absmiddle" border="0"></a>&nbsp;   -->                
        	        </td>
                    <td colspan=2 class=title  width="14%"  >�����հ� </td>   
               </tr>      
               <tr>     
                    <td class=title>��� </td>
                    <td class=title>���� </td>
                    <td class=title>���� </td>
                    <td class=title>��� </td>
                    <td class=title>���� </td>
                    <td class=title>���� </td>
                    <td class=title>��� </td>
                    <td class=title>���� </td>
                    <td class=title>���� </td>
                    <td class=title>��� </td>
                    <td class=title>���� </td>
                     <td class=title>���� </td>
                    <td class=title width="7%">�� </td>        
                     <td class=title>��� </td>    
                </tr>           
            </table>
		</td>
	</tr>
	
  
<%if(vt_size > 0){%>
    <tr>		
        <td class='line'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				if ( i == 0 ) {
				    loan_chk = String.valueOf(ht.get("LOAN_ST"));
				}		
											
				//��Ī
				dept_nm = ad_db.getUserDeptNm(String.valueOf(ht.get("USER_ID")));
						
				float t1=0;
				float t2=0;
				float t3=0;
				float t4=0;
				float t5=0; //��
				float t_ave_per = 0;
				
				float ct1=0;
				float ct2=0;
				float ct3=0;
				float ct4=0;
			
				// gubun2 : 1:ä�� 	
			
				t1=AddUtil.parseFloat(String.valueOf(ht.get("D1"))); //ä��ķ����(1)				
				t2=AddUtil.parseFloat(String.valueOf(ht.get("D2"))); //ä��ķ����(2)
				t3=AddUtil.parseFloat(String.valueOf(ht.get("D3"))); //ä��ķ����(3)
				t4=AddUtil.parseFloat(String.valueOf(ht.get("D4"))); //ä��ķ����(4)
			//	t_ave_per=AddUtil.parseFloat(String.valueOf(ht.get("AVE_PER"))); //��տ�ü��(4)
				
				ct1=AddUtil.parseFloat(String.valueOf(ht.get("CD1"))); //ä��ķ����(1)	- ����			
				ct2=AddUtil.parseFloat(String.valueOf(ht.get("CD2"))); //ä��ķ����(2)
				ct3=AddUtil.parseFloat(String.valueOf(ht.get("CD3"))); //ä��ķ����(3)
				ct4=AddUtil.parseFloat(String.valueOf(ht.get("CD4"))); //ä��ķ����(4)
				
				t_amt1[1] += t1;  //total
				t_amt2[1] += t2;
				t_amt3[1] += t3;
				t_amt4[1] += t4;
				
				ct_amt1[1] += ct1;  //total
				ct_amt2[1] += ct2;
				ct_amt3[1] += ct3;
				ct_amt4[1] += ct4;
  								
	%>			

         	<tr> 
         	  	 <td width='2%' align='center'><%=i+1%></td>
                    <td width='10%' align='center'>
           <%  if ( ht.get("NM").equals("�����")) { %>
           �����
           <% } else { %>
           <%    if (ht.get("LOAN_ST").equals("2")){ %>
                   <%=dept_nm%>&nbsp;<% if ( dept_nm.equals("�λ�����") || dept_nm.equals("��������") ) { %>���� <%}%>                            
          
           <%}else if( ht.get("LOAN_ST").equals("4")){%>
           			<%=dept_nm%>&nbsp;<% if ( dept_nm.equals("�λ�����") || dept_nm.equals("��������") ) { %>���� <%}%>   
            
           <%}else if( ht.get("LOAN_ST").equals("5")){%><%=dept_nm%> <%}%>
           <% } %>     
                    </td>
                    <td width='7%' align='center'><%=ht.get("USER_NM")%></td>
                    <td width='7%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%></td>
                    <td width='5%' align='right'><%=AddUtil.parseFloatCipher2(t1, 3)%></td> <!--1 -->
                    <td width='5%' align='right'><%=AddUtil.parseFloatCipher2(ct1, 3)%></td> <!--1 -->
                    <td width='5%' align='right'><%=AddUtil.parseFloatCipher2(t1+ct1, 3)%></td> <!--1 -->
                    <td width='5%' align='right'><%=AddUtil.parseFloatCipher2(t2, 3)%></td> <!--2 -->	
                    <td width='5%' align='right'><%=AddUtil.parseFloatCipher2(ct2, 3)%></td> <!--2 -->
                    <td width='5%' align='right'><%=AddUtil.parseFloatCipher2(t2+ct2, 3)%></td> <!--2 -->
        		  <td width='5%' align='right'><%=AddUtil.parseFloatCipher2(t3, 3)%></td> <!--3 -->	
        		   <td width='5%' align='right'><%=AddUtil.parseFloatCipher2(ct3, 3)%></td> <!--3 -->
                     <td width='5%' align='right'><%=AddUtil.parseFloatCipher2(t3+ct3, 3)%></td> <!--3 -->
        		    <td width='5%' align='right'><%=AddUtil.parseFloatCipher2(t4, 3)%></td> <!--4 -->	
        		    <td width='5%' align='right'><%=AddUtil.parseFloatCipher2(ct4, 3)%></td> <!--4 -->
                    <td width='5%' align='right'><%=AddUtil.parseFloatCipher2(t4+ct4, 3)%></td> <!--4 -->
        		   <td width='7%' align='right'><%=AddUtil.parseFloatCipher2(t1+ct1+t2+ct2+t3+ct3+t4+ct4, 3)%></td> 	
        		    <td width='7%' align='right'><%=AddUtil.parseFloatCipher2((t1+ct1+t2+ct2+t3+ct3+t4+ct4)/4, 3)%></td> 	
                </tr>
 
<%		}	%>		    
	
	   <tr  height="80"> 
		  	<td class=title colspan="4" style='height:44;'>�հ�<br>���</td>
		            <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt1[1])%><br><%=Util.parseDecimal(t_amt1[1]/vt_size)%></td> <!--1 -->
		            <td class=title  style='text-align=right'><%=Util.parseDecimal(ct_amt1[1])%><br><%=Util.parseDecimal(ct_amt1[1]/vt_size)%></td> <!--1 -->
                    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt1[1]+ct_amt1[1])%><br><%=Util.parseDecimal((t_amt1[1]+ct_amt1[1])/vt_size)%></td><!--1-->
        		    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt2[1])%><br><%=Util.parseDecimal(t_amt2[1]/vt_size)%></td> <!--2 -->	
        		    <td class=title  style='text-align=right'><%=Util.parseDecimal(ct_amt2[1])%><br><%=Util.parseDecimal(ct_amt2[1]/vt_size)%></td> <!--2 -->
                    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt2[1]+ct_amt2[1])%><br><%=Util.parseDecimal((t_amt2[1]+ct_amt2[1])/vt_size)%></td> <!--2 -->
        		    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt3[1])%><br><%=Util.parseDecimal(t_amt3[1]/vt_size)%></td> <!--3 -->  
        		    <td class=title  style='text-align=right'><%=Util.parseDecimal(ct_amt3[1])%><br><%=Util.parseDecimal(ct_amt3[1]/vt_size)%></td> <!--3 -->
                    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt3[1]+ct_amt3[1])%><br><%=Util.parseDecimal((t_amt3[1]+ct_amt3[1])/vt_size)%></td><!--3 -->
        		    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt4[1])%><br><%=Util.parseDecimal(t_amt4[1]/vt_size)%></td> <!--4 -->	
        		    <td class=title  style='text-align=right'><%=Util.parseDecimal(ct_amt4[1])%><br><%=Util.parseDecimal(ct_amt4[1]/vt_size)%></td> <!--4 -->
                    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt4[1]+ct_amt4[1])%><br><%=Util.parseDecimal((t_amt4[1]+ct_amt4[1])/vt_size)%></td><!--4 -->
        		   <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt1[1]+ct_amt1[1]+t_amt2[1]+ct_amt2[1]+t_amt3[1]+ct_amt3[1]+t_amt4[1]+ct_amt4[1])%><br><%=Util.parseDecimal((t_amt1[1]+ct_amt1[1]+t_amt2[1]+ct_amt2[1]+t_amt3[1]+ct_amt3[1]+t_amt4[1]+ct_amt4[1])/vt_size)%></td>  	   
        		   <td class=title  style='text-align=right'></td>    		    
        		
		        </tr>
	        </table>
	    </td>		  
<%	}else{	%>                     
  <tr>		
        <td class='line' width='100%'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center' >��ϵ� ����Ÿ�� �����ϴ�</td>
                </tr>
            </table>
	    </td>
	   
  </tr>
<%	}	%>
</table>	
<!-- �򰡱��� -->
  <table width="1000" border="0" cellspacing="0" cellpadding="0">
  	<tr> 
      <td colspan=2><font color="#FF00FF">�� ����</font>       :  ����->: ķ���� �Ⱓ�� 1�� ��ü���� ķ���θ��� ��ü������ ��ü������  
        &nbsp;&nbsp;</td>
   	</tr>
   </table>	
<form action="" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='gubun1' value=>
<input type='hidden' name='gubun2' value=>
</form>
</body>
</html>
