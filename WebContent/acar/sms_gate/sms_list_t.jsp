<%@ page language="java" contentType="text/html;charset=euc-kr"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	var checkflag = "true";
	function AllSelect(field){
		if(checkflag == "false"){
			for(i=0; i<field.length; i++){
				field[i].checked = true;
			}
			checkflag = "true";
			return;
		}else{
			for(i=0; i<field.length; i++){
				field[i].checked = false;
			}
			checkflag = "false";
			return;
		}
	}

//-->
</script>
</head>

<body>
<table width="600" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width="580" border="0" cellspacing="0" cellpadding="0">
        		<tr><td class=line2></td></tr>
                <tr> 
                    <td width="580" colspan="2" class="line">
                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                                <td width="27" class="title"><input type="checkbox" name="all_pr" value="Y" checked onclick='javascript:AllSelect(parent.smsList_in.form1.pr)'></td>
                                <td width="27" class="title">����</td>
                                <td width="49" class="title">�Ҽӻ�</td>
                                <td width="83" class="title">�ٹ�����</td>
                                <td width="73" class="title">�ٹ�ó</td>
                                <td width="55" class="title">����</td>
                                <td width="90" class="title">�޴�����ȣ</td>
                                <td width="55" class="title">�߼۱���</td>
                                <td width="55" class="title">��������</td>
                                <td width="55" class="title">�ŷ�����</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
	    </td>
    </tr>
</table>
</body>
</html>
