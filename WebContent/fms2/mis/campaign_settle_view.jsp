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
	Vector vt = ac_db.getStatCmpList(gubun1, gubun2, "3");
			
	int vt_size =vt.size();
	
	long t_amt1[] = new long[2];   
    long t_amt2[] = new long[2];   
    long t_amt3[] = new long[2];   
    long t_amt4[] = new long[2];   
    long t_amt5[] = new long[2];   
    long t_amt6[] = new long[2];   
    long t_amt7[] = new long[2];   
    long t_amt8[] = new long[2];
    long t_amt9[] = new long[2];
       
    long t_amt10[] = new long[2];  //���
    long t_amt11[] = new long[2];  //����
    
    long t_amt12[] = new long[2];  //���
    long t_amt13[] = new long[2];  //����	
    
    long t_amt14[] = new long[2];  //����	
    long t_amt15[] = new long[2];  //���	
    
    long t_amt20[] = new long[2];
    long t_amt21[] = new long[2];
    long t_amt22[] = new long[2];  
    long t_amt23[] = new long[2];  
   	       
    String loan_chk = "";
    int    loan_cnt = 1;
    int    t_loan_cnt = 0;
    
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
					
	}    
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--

//-->
</script>
<script language='javascript'>
<!-- 
   //��������Ÿ�� ���� -- ���Ұ� 20201016
	function stat_search(mode, bus_id2){	
		var fm = document.form1;	
		parent.location.href = "/acar/arrear/arrear_long_frame_s.jsp?gubun1=1&gubun2=3&gubun3=3&gubun4=4&s_kd=8&t_wd="+bus_id2;		
	}	
	
	//����Ʈȭ�麸��	
	function cmp_print(){
		var fm = document.form1;
		var i_fm = i_view.form1;
		i_fm.gubun1.value = fm.gubun1.value;	
		i_fm.gubun2.value = fm.gubun2.value;	
		window.open("campaign_settle_view_print.jsp?gubun2=1&gubun1="+i_fm.gubun1.value,"print","left=30,top=50,width=1050,height=850,scrollbars=yes");	
	}
	
	function viewCamaign(gubun1, gubun2)
	{
		if ( gubun2 == '�ܱ�') { //�ܱ�
		 	window.open("/fms2/mis/prop_settle6.jsp?save_dt="+gubun1, "viewCamaign", "left=100, top=20, width=1000, height=900, scrollbars=auto");
		} else { //����
			window.open("/fms2/mis/prop_settle.jsp?save_dt="+gubun1, "viewCamaign", "left=100, top=20, width=1000, height=900, scrollbars=auto");
		}
		
	}
//-->
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
                   <td width="3%" class='title' >����</td>
                    <td width="10%" class='title' >����</td>
                    <td width="8%" class='title'>����</td>
                    <td width="11%" class='title'>�Ի���</td>
                    <td class=title width="13%" >1
                  <!--   <a href="javascript:viewCamaign('<%=vt_dt[0]%>', '����')" onMouseOver="window.status=''; return true" hover><img src="http://fms1.amazoncar.co.kr/acar/images/center/icon_memo.gif"  align="absmiddle" border="0"></a>&nbsp;   -->                
                    </td>
                    <td class=title width="13%" >2
                   <!-- <a href="javascript:viewCamaign('<%=vt_dt[1]%>', '����')" onMouseOver="window.status=''; return true" hover><img src="http://fms1.amazoncar.co.kr/acar/images/center/icon_memo.gif"  align="absmiddle" border="0"></a>&nbsp;   -->                
                    </td>
                    <td class=title width="13%" >3
                   <!--  <a href="javascript:viewCamaign('<%=vt_dt[2]%>', '����')" onMouseOver="window.status=''; return true" hover><img src="http://fms1.amazoncar.co.kr/acar/images/center/icon_memo.gif"  align="absmiddle" border="0"></a>&nbsp; -->
                   </td>
                    <td class=title width="13%" >4</td>
                    <td class=title width="15%" >�հ�</td>
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
							
				//��Ī
				dept_nm = ad_db.getUserDeptNm(String.valueOf(ht.get("USER_ID")));
													
				long s0=0;
				long d0=0;	
				long c0=0;		
				long p0=0;		
											
				long t1=0;
				long t2=0;
				long t3=0;
				long t4=0;
				long t5=0;
				long t6=0;
							
				t1=AddUtil.parseLong(String.valueOf(ht.get("P1"))); //����ķ����(1)	
				t2=AddUtil.parseLong(String.valueOf(ht.get("P2"))); //����ķ����(2)
				t3=AddUtil.parseLong(String.valueOf(ht.get("P3"))); //����ķ����(3)
				
				t6=t1 + t2 + t3  ; //ķ���� �Ѱ� (���κ�)
											
				for(int j=0; j<1; j++){
						t_amt1[j] += t1;
						t_amt2[j] += t2;
						t_amt3[j] += t3;										
				}
				
			
				if ( i == 0 ) {
				    loan_chk = String.valueOf(ht.get("LOAN_ST"));
				}
								
		%>		
					
           		<tr> 
           	 <td width='3%' align='center'><%=i+ 1%></td>
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
                    <td width='8%' align='center'><%=ht.get("USER_NM")%></td>
                    <td width='11%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%></td>
                    <td width='13%' align='right'><%=Util.parseDecimal(t1)%></td> <!--1�б� -->
        		    <td width='13%' align='right'><%=Util.parseDecimal(t2)%></td>	
        		    <td width='13%' align='right'><%=Util.parseDecimal(t3)%></td>	
        		    <td width='13%' align='right'><%=Util.parseDecimal(t4)%></td> <!--2�б� -->					
        		    <td width='15%' align='right'><%=Util.parseDecimal(t1+t2+t3)%></td> 
                </tr>
 
<%		}	%>		    

		         <tr  height="80"> 
		        	<td  class=title align='center' colspan=4   style='height:44;'>�հ�<br>���</td>
        		    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[0])%><br><%=Util.parseDecimal(t_amt1[0]/vt_size)%></td> <!--1�б� -->
        		    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt2[0])%><br><%=Util.parseDecimal(t_amt2[0]/vt_size)%></td>	
        		    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt3[0])%><br><%=Util.parseDecimal(t_amt3[0]/vt_size)%></td>	 
        		    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt4[0])%><br><%=Util.parseDecimal(t_amt4[0]/vt_size)%></td>	<!--2�б� -->				
        		    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[0]+t_amt2[0]+t_amt3[0])%><br><%=Util.parseDecimal((t_amt1[0]+t_amt2[0]+t_amt3[0])/vt_size)%></td>
        	
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
      <td colspan=2><font color="#FF00FF">�� ����</font>       :   ��������  
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
