<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cost.*"%>

<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1"); //�⵵
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2"); //�׸�
		
	// gubun2 : 2:���� 1:ä�� 5:��� 6:����	
	Vector vt = ac_db.getStatCmpList(gubun1, gubun2, "");
		
	int vt_size =vt.size();
	
	float t_amt1[] = new float[2];   
    float t_amt2[] = new float[2];   
    float t_amt3[] = new float[2];   
    float t_amt4[] = new float[2];   
    float t_amt5[] = new float[2];   
      
    long t_amt21[] = new long[2];
    long t_amt22[] = new long[2];  
    long t_amt23[] = new long[2];  
    long t_amt24[] = new long[2];  
    
    String loan_chk = "";
    int    loan_cnt = 1;
    int    t_loan_cnt = 1;
    
    int tp_amt0 = 0;
    int tp_amt1 = 0;
    int tp_amt2 = 0;
    int tp_amt3 = 0;      
    
    String dept_nm = "";
    
    int vt_cnt = 0;
       
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
//�˾������� ���� -- ��������Ÿ�� ���� - 20200116 ���Ұ�
function viewCamaign(gubun1, gubun2)
{
	if ( gubun2 == '1') { //1��
	 	window.open("/acar/stat_month/campaign2019_5_sc1.jsp?save_dt="+gubun1, "viewCamaign", "left=100, top=20, width=1000, height=900, scrollbars=auto");
	} else { //2��
		window.open("/acar/stat_month/campaign2019_5_sc2.jsp?save_dt="+gubun1, "viewCamaign", "left=100, top=20, width=1000, height=900, scrollbars=auto");
	}
	
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
                    <td width="2%" class='title' >����</td>
                    <td width="12%" class='title' >����</td>
                    <td width="9%" class='title'>����</td>
                    <td width="9%" class='title'>�Ի���</td>
                    <td class=title width="12%" >1
                <!--      <a href="javascript:viewCamaign('<%=vt_dt[0]%>', '1')" onMouseOver="window.status=''; return true" hover>[1��]</a>&nbsp;
                     <a href="javascript:viewCamaign('<%=vt_dt[0]%>', '2')" onMouseOver="window.status=''; return true" hover>[2��]</a>  -->                  
                    </td>
                    <td class=title width="12%" >2
                 <!--     <a href="javascript:viewCamaign('<%=vt_dt[1]%>', '1')" onMouseOver="window.status=''; return true" hover>[1��]</a>&nbsp;
                     <a href="javascript:viewCamaign('<%=vt_dt[1]%>', '2')" onMouseOver="window.status=''; return true" hover>[2��]</a>  -->
                    </td>
                    <td class=title width="12%" >3
                <!--      <a href="javascript:viewCamaign('<%=vt_dt[2]%>', '1')" onMouseOver="window.status=''; return true" hover>[1��]</a>&nbsp;
                     <a href="javascript:viewCamaign('<%=vt_dt[2]%>', '2')" onMouseOver="window.status=''; return true" hover>[2��]</a>  -->
                    </td>
                    <td class=title width="12%" >4
                 <!--     <a href="javascript:viewCamaign('<%=vt_dt[3]%>', '1')" onMouseOver="window.status=''; return true" hover>[1��]</a>&nbsp;
                     <a href="javascript:viewCamaign('<%=vt_dt[3]%>', '2')" onMouseOver="window.status=''; return true" hover>[2��]</a>   -->
                    </td>
                    <td class=title width="12%" >��</td>
                   
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
			
				// gubun2 : 2:���� 1:ä�� 5:��� 6:����	
				if ( gubun2.equals("2") )  { //����									
					t1=AddUtil.parseFloat(String.valueOf(ht.get("S1"))); //����ķ����(1)				
					t2=AddUtil.parseFloat(String.valueOf(ht.get("S2"))); //����ķ����(2)
					t3=AddUtil.parseFloat(String.valueOf(ht.get("S3"))); //����ķ����(3)
					t4=AddUtil.parseFloat(String.valueOf(ht.get("S4"))); //����ķ����(4)
				} else if ( gubun2.equals("5") ) {								
					t1=AddUtil.parseFloat(String.valueOf(ht.get("C1"))); //���ķ����(1)					
					t2=AddUtil.parseFloat(String.valueOf(ht.get("C2"))); //���ķ����(2)
					t3=AddUtil.parseFloat(String.valueOf(ht.get("C3"))); //���ķ����(3)
				} else if ( gubun2.equals("6") ) {	
					t1=AddUtil.parseFloat(String.valueOf(ht.get("P1"))); //����ķ����(1)	
					t2=AddUtil.parseFloat(String.valueOf(ht.get("P2"))); //����ķ����(2)
					t3=AddUtil.parseFloat(String.valueOf(ht.get("P3"))); //����ķ����(3)
				}
				
				t_amt1[1] += t1;  //total
				t_amt2[1] += t2;
				t_amt3[1] += t3;
				t_amt4[1] += t4;

  				if ( loan_chk.equals(String.valueOf(ht.get("LOAN_ST")))) {        
  								
					for(int j=0; j<1; j++){
							t_amt1[j] += t1;
							t_amt2[j] += t2;
							t_amt3[j] += t3;
							t_amt4[j] += t4;					
					}
					vt_cnt += 1;
				}
				
	%>			
<%    if ( !loan_chk.equals(String.valueOf(ht.get("LOAN_ST")))) {  %>        
                <tr  height="80"> 
                    <td class=title colspan="4" style='height:34;'>�Ұ�<br>���</td>
                    <td  class=title  style='text-align=right'><%=Util.parseDecimal(t_amt1[0])%><br><%=Util.parseDecimal(t_amt1[0]/vt_cnt)%></td> <!--1 -->
        		    <td  class=title  style='text-align=right'><%=Util.parseDecimal(t_amt2[0])%><br><%=Util.parseDecimal(t_amt2[0]/vt_cnt)%></td> <!--2 -->	
        		    <td  class=title  style='text-align=right'><%=Util.parseDecimal(t_amt3[0])%><br><%=Util.parseDecimal(t_amt3[0]/vt_cnt)%></td>	<!--3 -->  
        		    <td  class=title  style='text-align=right'><%=Util.parseDecimal(t_amt4[0])%><br><%=Util.parseDecimal(t_amt4[0]/vt_cnt)%></td>	<!--4 -->	
        		    <td  class=title  style='text-align=right'><%=Util.parseDecimal(t_amt1[0]+t_amt2[0]+t_amt3[0]+t_amt4[0])%><br><%=Util.parseDecimal((t_amt1[0]+t_amt2[0]+t_amt3[0]+t_amt4[0])/vt_cnt)%></td> <!--1 -->		
                </tr>
<%		
       		 loan_chk = String.valueOf(ht.get("LOAN_ST"));
       		 
			 t_amt1[0] = t1;
			 t_amt2[0] = t2;
			 t_amt3[0] = t3;
		 	 t_amt4[0] = t4;	
		 	 
		 	 vt_cnt = 1;
		 	 
        }
%>   
           		<tr> 
           		      <td width='2%' align='center'><%=i+ 1 %></td>
                    <td width='12%' align='center'>
           <%  if ( ht.get("NM").equals("�����")) { %>
           �����
           <% } else { %>
           <%    if (ht.get("LOAN_ST").equals("2")){ %>
                   <%=dept_nm%>&nbsp;<% if ( dept_nm.equals("�λ�����") || dept_nm.equals("��������")   || dept_nm.equals("�뱸����")   || dept_nm.equals("��������")   || dept_nm.equals("��������")  ) { %> <%}%>                            
          
           <%}else if( ht.get("LOAN_ST").equals("4")){%>
           			<%=dept_nm%>&nbsp;<% if ( dept_nm.equals("�λ�����") || dept_nm.equals("��������")   || dept_nm.equals("�뱸����")   || dept_nm.equals("��������")  || dept_nm.equals("��������")   ) { %> <%}%>   
            
           <%}else if( ht.get("LOAN_ST").equals("5")){%><%=dept_nm%> <%}%>
           <% } %>     
                    </td>
                    <td width='9%' align='center'><%=ht.get("USER_NM")%></td>
                    <td width='9%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%></td>
                    <td width='12%' align='right'><%=AddUtil.parseFloatCipher2(t1, 2)%></td> <!--1 -->
                    <td width='12%' align='right'><%=AddUtil.parseFloatCipher2(t2, 2)%></td> <!--2 -->	
        		    <td width='12%' align='right'><%=AddUtil.parseFloatCipher2(t3, 2)%></td> <!--3 -->	
        		    <td width='12%' align='right'><%=AddUtil.parseFloatCipher2(t4, 2)%></td> <!--4 -->	
        		    <td width='12%' align='right'><%=AddUtil.parseFloatCipher2(t1+t2+t3+t4, 2)%></td> 	
                </tr>
 
<%		}	%>		    
			    <tr  height="80"> 
                    <td class=title colspan="4" style='height:34;'>�Ұ�<br>���</td>
                    <td  class=title  style='text-align=right'><%=Util.parseDecimal(t_amt1[0])%><br><%=Util.parseDecimal(t_amt1[0]/vt_cnt)%></td> <!--1 -->
        		    <td  class=title  style='text-align=right'><%=Util.parseDecimal(t_amt2[0])%><br><%=Util.parseDecimal(t_amt2[0]/vt_cnt)%></td> <!--2 -->	
        		    <td  class=title  style='text-align=right'><%=Util.parseDecimal(t_amt3[0])%><br><%=Util.parseDecimal(t_amt3[0]/vt_cnt)%></td> <!--3 -->  
        		    <td  class=title  style='text-align=right'><%=Util.parseDecimal(t_amt4[0])%><br><%=Util.parseDecimal(t_amt4[0]/vt_cnt)%></td> <!--4 -->		
        		    <td  class=title  style='text-align=right'><%=Util.parseDecimal(t_amt1[0]+t_amt2[0]+t_amt3[0]+t_amt4[0])%><br><%=Util.parseDecimal((t_amt1[0]+t_amt2[0]+t_amt3[0]+t_amt4[0])/vt_cnt)%></td> <!--4 -->			
                </tr>
		        <tr  height="80"> 
		        	<td class=title colspan="4" style='height:34;'>�հ�<br>���</td>
        		    <td  class=title  style='text-align=right'><%=Util.parseDecimal(t_amt1[1])%><br><%=Util.parseDecimal(t_amt1[1]/vt_size)%></td> <!--1 -->
        		    <td  class=title  style='text-align=right'><%=Util.parseDecimal(t_amt2[1])%><br><%=Util.parseDecimal(t_amt2[1]/vt_size)%></td> <!--2 -->	
        		    <td  class=title  style='text-align=right'><%=Util.parseDecimal(t_amt3[1])%><br><%=Util.parseDecimal(t_amt3[1]/vt_size)%></td> <!--3 -->  
        		    <td  class=title  style='text-align=right'><%=Util.parseDecimal(t_amt4[1])%><br><%=Util.parseDecimal(t_amt4[1]/vt_size)%></td> <!--4 -->	
        		    <td  class=title  style='text-align=right'><%=Util.parseDecimal(t_amt1[1]+t_amt2[1]+t_amt3[1]+t_amt4[1])%><br><%=Util.parseDecimal((t_amt1[1]+t_amt2[1]+t_amt3[1]+t_amt4[1])/vt_size)%></td> <!--4 -->	
        		    
        		
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
      <td colspan=2><font color="#FF00FF">�� ����</font>       : ķ���ν���
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
